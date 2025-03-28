import 'package:leeds_library/data/models/reader.dart';

abstract class AddReaderState {}

class AddReaderInitial extends AddReaderState {}

class AddReaderLoading extends AddReaderState {}

class AddReaderSuccess extends AddReaderState {
  final Reader reader;
  AddReaderSuccess(this.reader);
}

class AddReaderFailure extends AddReaderState {
  final String error;
  AddReaderFailure(this.error);
}
