abstract class TextRecognizerEvent {}

class RequestCameraPermission extends TextRecognizerEvent {}

class CaptureImageForRecognition extends TextRecognizerEvent {
  final String imagePath;
  CaptureImageForRecognition(this.imagePath);
}
