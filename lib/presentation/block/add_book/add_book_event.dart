

import 'dart:io';

import 'package:image_picker/image_picker.dart';

abstract class AddBookEvent {}

class SubmitBookEvent extends AddBookEvent {
  final String title;
  final String author;
  final String genre;
  final String publisher;
  final String barcode;
  final File? imageFile;

  SubmitBookEvent({
    required this.title,
    required this.author,
    required this.genre,
    required this.publisher,
    required this.barcode,
    this.imageFile,
  });
}

class PickImageEvent extends AddBookEvent {
  final ImageSource source;
  PickImageEvent(this.source);
}
