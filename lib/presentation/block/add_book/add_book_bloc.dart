import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/data/net/result.dart';
import 'package:leeds_library/domain/repositories/books_repository.dart';

import 'add_book_event.dart';
import 'add_book_state.dart';

class AddBookBloc extends Bloc<AddBookEvent, AddBookState> {
  final BooksRepository _bookApiService;
  final ImagePicker _picker = ImagePicker();

  AddBookBloc(this._bookApiService) : super(AddBookInitial()) {
    on<SubmitBookEvent>(_onSubmitBook);
    on<PickImageEvent>(_onPickImage);
  }

  Future<void> _onSubmitBook(
      SubmitBookEvent event, Emitter<AddBookState> emit) async {
    emit(AddBookLoading());

    try {
      String? imageUrl;
      if (event.imageFile != null) {
        imageUrl = await _uploadImageToStorage(event.imageFile!);
      }

      Book newBook = Book(
        id: "",
        title: event.title,
        author: event.author,
        genre: event.genre,
        publisher: event.publisher,
        description: event.description ?? "",
        imageUrl: imageUrl ?? "",
        barcode: event.barcode,
        isAvailable: true,
        averageRating: 0.0,
        reviewsCount: 0,
      );

      Result<Book?, String> result = await _bookApiService.createBook(newBook);

      if (result.isSuccess) {
        emit(AddBookSuccess());
      } else {
        emit(AddBookFailure(result.error ?? "Error adding book"));
      }
    } catch (e) {
      emit(AddBookFailure("Unexpected error: $e"));
    }
  }

  Future<void> _onPickImage(
      PickImageEvent event, Emitter<AddBookState> emit) async {
    final pickedFile = await _picker.pickImage(source: event.source);
    if (pickedFile != null) {
      emit(AddBookImagePicked(File(pickedFile.path)));
    }
  }

  Future<String> _uploadImageToStorage(File image) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child("book_images/${DateTime.now().millisecondsSinceEpoch}.jpg");
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }
}
