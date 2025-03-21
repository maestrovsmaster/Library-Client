import 'package:equatable/equatable.dart';

abstract class BarcodeScannerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RequestCameraPermission extends BarcodeScannerEvent {}

class BarcodeScanned extends BarcodeScannerEvent {
  final String code;

  BarcodeScanned(this.code);

  @override
  List<Object?> get props => [code];
}
