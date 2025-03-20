import 'dart:io';

abstract class AddBookState {}

class AddBookInitial extends AddBookState {}

class AddBookLoading extends AddBookState {}

class AddBookSuccess extends AddBookState {}

class AddBookFailure extends AddBookState {
  final String error;
  AddBookFailure(this.error);
}

class AddBookImagePicked extends AddBookState {
  final File imageFile;
  AddBookImagePicked(this.imageFile);
}
