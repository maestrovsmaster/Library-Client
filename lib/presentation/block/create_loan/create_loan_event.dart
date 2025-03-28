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
