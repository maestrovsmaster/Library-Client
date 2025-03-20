import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leeds_library/presentation/block/text_recognize/text_recognize_block.dart';
import 'package:leeds_library/presentation/block/text_recognize/text_recognize_state.dart';
import 'package:leeds_library/presentation/widgets/camera_view/camera_view.dart';

import '../block/text_recognize/text_recognize_event.dart';

class TextRecognizeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TextRecognizerBloc()..add(RequestCameraPermission()),
      child: Scaffold(
        appBar: AppBar(title: Text('Recognize Text')),
        body: BlocBuilder<TextRecognizerBloc, TextRecognizerState>(
          builder: (context, state) {
            if (state is CameraPermissionDenied) {
              return Center(child: Text("Camera permission denied"));
            }
            if (state is TextRecognitionSuccess) {
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Recognized Text:", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text(
                        state.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      //CircularProgressIndicator(),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => context
                            .read<TextRecognizerBloc>()
                            .add(RequestCameraPermission()),
                        child: Text("Scan Again"),
                      ),
                    ],
                  ));
              }
                  if (state is TextRecognitionError) {
                return Center(child: Text("Error: ${state.errorMessage}"));
              }
              return CameraView(
                onImageCaptured: (XFile image) {
                  context.read<TextRecognizerBloc>().add(CaptureImageForRecognition(image.path));
                },
              );
            },
        ),
      ),
    );
  }
}