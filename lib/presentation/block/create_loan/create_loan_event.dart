import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/data/models/reader.dart';

abstract class CreateLoanEvent {}

class SearchReaderEvent extends CreateLoanEvent {
  final String query;
  SearchReaderEvent(this.query);
}

class SelectReaderEvent extends CreateLoanEvent {
  final Reader reader;
  SelectReaderEvent(this.reader);
}

class AddLoanEvent extends CreateLoanEvent{
  final Book book;
  final Reader reader;
  AddLoanEvent(this.book, this.reader);
}
