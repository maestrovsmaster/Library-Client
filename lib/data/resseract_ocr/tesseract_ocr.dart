import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class TesseractService {
  static Future<String> extractText(String imagePath, {String lang = 'ukr'}) async { //'ukr+eng'
    final tessDataPath = await _prepareTessdata();
    final recognizedText = await FlutterTesseractOcr.extractText(
      imagePath,
      language: 'ukr',//lang,
      args: {
        //"preserve_interword_spaces": "1",
        'tessdata': tessDataPath,
        //"user_defined_dpi": "300",
      },

    );

    /*final recognizedText2 = await FlutterTesseractOcr.extractText(
      imagePath,
      language: 'ukr',//lang,
      args: {
       // "preserve_interword_spaces": "1",
        'tessdata': tessDataPath,
        "user_defined_dpi": "300",
      },

    );*/
    return recognizedText;
  }

  static Future<String> _prepareTessdata() async {
    final dir = await getApplicationDocumentsDirectory();
    final tessdataPath = '${dir.path}/tessdata';

    final tessdataDir = Directory(tessdataPath);
    if (!tessdataDir.existsSync()) {
      tessdataDir.createSync(recursive: true);
    }

    final languages = ['ukr', 'eng'];
    for (final lang in languages) {
      final bytes = await rootBundle.load('assets/tessdata/$lang.traineddata');
      final file = File('$tessdataPath/$lang.traineddata');
      if (!file.existsSync()) {
        await file.writeAsBytes(bytes.buffer.asUint8List());
      }
    }

    return tessdataPath;
  }
}
