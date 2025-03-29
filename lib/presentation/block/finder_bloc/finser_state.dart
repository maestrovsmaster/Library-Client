
import 'package:equatable/equatable.dart';
import 'package:leeds_library/data/models/book.dart';

abstract class FinderState extends Equatable {
  const FinderState();

  @override
  List<Object> get props => [];
}


class BooksInitialState extends FinderState {}


class FinderBooksListState extends FinderState {
  final Stream<List<Book>> booksStream;

  const FinderBooksListState(this.booksStream);

  @override
  List<Object> get props => [booksStream];
}


class BooksErrorState extends FinderState {
  final String message;

  const BooksErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class SuccessReturnBookState extends FinderState {
  const SuccessReturnBookState();
}

