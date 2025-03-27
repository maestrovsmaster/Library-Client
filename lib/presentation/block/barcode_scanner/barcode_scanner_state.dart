
import 'package:equatable/equatable.dart';
import 'package:leeds_library/data/models/book.dart';

abstract class BarcodeScannerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BarcodeScannerInitial extends BarcodeScannerState {}

class BarcodeScannerReady extends BarcodeScannerState {}

class BarcodeScannerPermissionDenied extends BarcodeScannerState {}

class BarcodeScannerSuccess extends BarcodeScannerState {
  final String barcode;

  BarcodeScannerSuccess(this.barcode);

  @override
  List<Object?> get props => [barcode];
}

class BookNotFound extends BarcodeScannerState {
  final String barcode;
  BookNotFound(this.barcode);
  @override
  List<Object?> get props => [barcode];
}

class BookFound extends BarcodeScannerState {
  final String barcode;
  final Book book;
  BookFound(this.barcode, this.book);
  @override
  List<Object?> get props => [barcode, book];
}

class ServerError extends BarcodeScannerState {
  final String error;
  ServerError(this.error);
  @override
  List<Object?> get props => [error];
}

