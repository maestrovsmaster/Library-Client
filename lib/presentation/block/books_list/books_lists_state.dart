
import 'package:equatable/equatable.dart';
import 'package:leeds_library/data/models/book.dart';

abstract class BooksListState extends Equatable {
  const BooksListState();

  @override
  List<Object> get props => [];
}

/// Початковий стан
class BooksInitialState extends BooksListState {}

/// Стан із потоком даних
class BooksStreamState extends BooksListState {
  final List<String> categories;
  final Stream<List<Book>> booksStream;

  const BooksStreamState(this.categories, this.booksStream);

  @override
  List<Object> get props => [booksStream];
}

/// Помилка при завантаженні
class BooksErrorState extends BooksListState {
  final String message;

  const BooksErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class BarcodeUpdated extends BooksListState {}