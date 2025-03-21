import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/presentation/widgets/barcode_scanner_dialog/bloc/scanner_event.dart';
import 'package:leeds_library/presentation/widgets/barcode_scanner_dialog/bloc/scanner_state.dart';
import 'package:permission_handler/permission_handler.dart';

class BarcodeScannerBloc
    extends Bloc<BarcodeScannerEvent, BarcodeScannerState> {


  BarcodeScannerBloc()
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
  }
}
