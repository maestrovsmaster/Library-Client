import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:leeds_library/data/resseract_ocr/tesseract_ocr.dart';
import 'package:permission_handler/permission_handler.dart';

import 'text_recognize_event.dart';
import 'text_recognize_state.dart';

class TextRecognizerBloc extends Bloc<TextRecognizerEvent, TextRecognizerState> {
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  TextRecognizerBloc() : super(TextRecognizerInitial()) {
    on<RequestCameraPermission>(_onRequestCameraPermission);
    on<CaptureImageForRecognition>(_onCaptureImage);
  }

  Future<void> _onRequestCameraPermission(
      RequestCameraPermission event, Emitter<TextRecognizerState> emit) async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      emit(CameraPermissionGranted());
    } else {
      emit(CameraPermissionDenied());
    }
  }

  Future<void> _onCaptureImage(
      CaptureImageForRecognition event, Emitter<TextRecognizerState> emit) async {
    emit(TextRecognitionLoading());
    try {
      final inputImage = InputImage.fromFilePath(event.imagePath);
     // final recognizedText = await _textRecognizer.processImage(inputImage);


      try {
        final recognizedText = await TesseractService.extractText(
          event.imagePath,
          lang: 'ukr',//'ukr+eng',

        );
        emit(TextRecognitionSuccess(recognizedText));
      } catch (e) {
        emit(TextRecognitionError(e.toString()));
      }

    //  emit(TextRecognitionSuccess(recognizedText.text));
    } catch (e) {
      emit(TextRecognitionError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _textRecognizer.close();
    return super.close();
  }
}
