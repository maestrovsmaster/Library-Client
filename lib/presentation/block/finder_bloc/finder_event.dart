import 'package:equatable/equatable.dart';
import 'package:leeds_library/data/models/book.dart';

abstract class FinderEvent extends Equatable {
  const FinderEvent();

  @override
  List<Object> get props => [];
}


class FinderLoadBooksEvent extends FinderEvent {}


class FinderSearchQueryChangedEvent extends FinderEvent {
  final String query;

  const FinderSearchQueryChangedEvent(this.query);

  @override
  List<Object> get props => [query];
}

class ReturnBookEventEvent extends FinderEvent {
  final Book book;
  const ReturnBookEventEvent(this.book);
}