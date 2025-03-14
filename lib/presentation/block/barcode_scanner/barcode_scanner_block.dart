import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:leeds_library/domain/repositories/books_repository.dart';
import 'package:permission_handler/permission_handler.dart';

import 'barcode_scanner_event.dart';
import 'barcode_scanner_state.dart';

class BarcodeScannerBloc
    extends Bloc<BarcodeScannerEvent, BarcodeScannerState> {
  BooksRepository booksRepository;

  BarcodeScannerBloc({required this.booksRepository})
      : super(BarcodeScannerInitial()) {
    on<RequestCameraPermission>(_onRequestCameraPermission);
    on<BarcodeScanned>(_onBarcodeScanned);
  }

  Future<void> _onRequestCameraPermission(
      RequestCameraPermission event, Emitter<BarcodeScannerState> emit) async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      emit(BarcodeScannerReady());
    } else {
      emit(BarcodeScannerPermissionDenied());
    }
  }

  void _onBarcodeScanned(
      BarcodeScanned event, Emitter<BarcodeScannerState> emit) async {
    emit(BarcodeScannerSuccess(event.code));
    print("event.code = ${event.code}");
    final bookResult = await booksRepository.getBookByBarcode(event.code);
    print("getBookByBarcode bookResult = $bookResult  isSuccess = ${bookResult.isSuccess}");
   /* if (bookResult.isSuccess) {
      final book = bookResult.data;
      if (book != null) {
        emit(BookFound(event.code, book));
      } else {
        print("getBookByBarcode BookNotFound");
        emit(BookNotFound(event.code));
      }
    } else {
      emit(ServerError(bookResult.error ?? "Unknown error"));
    }*/

    if (bookResult.isSuccess) {
      print("Book found: ${bookResult.data}");
      emit(BookFound(event.code, bookResult.data!));
    } else if (bookResult.isEmpty) {
      print("No book found with this barcode.");
      emit(BookNotFound(event.code));
    } else {
      print("Error: ${bookResult.error}");
      emit(ServerError(bookResult.error ?? "Unknown error"));
    }
  }
}
