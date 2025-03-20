abstract class TextRecognizerState {}

class TextRecognizerInitial extends TextRecognizerState {}

class CameraPermissionDenied extends TextRecognizerState {}

class CameraPermissionGranted extends TextRecognizerState {}

class TextRecognitionLoading extends TextRecognizerState {}

class TextRecognitionSuccess extends TextRecognizerState {
  final String text;
  TextRecognitionSuccess(this.text);
}

class TextRecognitionError extends TextRecognizerState {
  final String errorMessage;
  TextRecognitionError(this.errorMessage);
}