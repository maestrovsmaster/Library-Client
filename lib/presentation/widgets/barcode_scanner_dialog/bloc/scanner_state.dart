import 'package:equatable/equatable.dart';

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



class ServerError extends BarcodeScannerState {
  final String error;
  ServerError(this.error);
  @override
  List<Object?> get props => [error];
}
