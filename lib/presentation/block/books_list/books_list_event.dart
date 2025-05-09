import 'package:equatable/equatable.dart';

abstract class BooksListEvent extends Equatable {
  const BooksListEvent();

  @override
  List<Object> get props => [];
}

class LoadBooksEvent extends BooksListEvent {}

class SearchQueryChangedEvent extends BooksListEvent {
  final String query;

  const SearchQueryChangedEvent(this.query);

  @override
  List<Object> get props => [query];
}


class UpdateBarcode extends BooksListEvent {
  final String id;
  final String code;

  const UpdateBarcode(this.id, this.code);

  //@override
  //List<Object?> get props => [code];
}

