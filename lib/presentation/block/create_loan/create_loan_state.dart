import 'package:leeds_library/data/models/reader.dart';

abstract class CreateLoanState {}

class CreateLoanInitial extends CreateLoanState {}

class SelectReaderState extends CreateLoanState {
  final Reader reader;
  SelectReaderState(this.reader);
}

class CreateLoanLoading extends CreateLoanState {}

class CreateLoanReadersFound extends CreateLoanState {
  final List<Reader> readers;
  CreateLoanReadersFound(this.readers);
}

class CreateLoanFailure extends CreateLoanState {
  final String error;
  CreateLoanFailure(this.error);
}
