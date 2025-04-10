import 'package:equatable/equatable.dart';

abstract class BooksDetailsEvent extends Equatable {
  const BooksDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadBooksEvent extends BooksDetailsEvent {
  final String bookId;
  const LoadBooksEvent(this.bookId);
  @override
  List<Object> get props => [bookId];
}



