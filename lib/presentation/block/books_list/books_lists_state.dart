
import 'package:equatable/equatable.dart';
import 'package:leeds_library/data/models/book.dart';

abstract class BooksListState extends Equatable {
  const BooksListState();

  @override
  List<Object> get props => [];
}


class BooksInitialState extends BooksListState {}


class BooksStreamState extends BooksListState {
  final List<String> categories;
  final Stream<List<Book>> booksStream;

  const BooksStreamState(this.categories, this.booksStream);

  @override
  List<Object> get props => [booksStream];
}


class BooksErrorState extends BooksListState {
  final String message;

  const BooksErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class BarcodeUpdated extends BooksListState {}

class BarcodeUpdateError extends BooksListState {
  final String message;
  const BarcodeUpdateError(this.message);
}
