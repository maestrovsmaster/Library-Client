
import 'package:equatable/equatable.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/data/models/loan.dart';

abstract class ReadingPlansState extends Equatable {
  const ReadingPlansState();

  @override
  List<Object> get props => [];
}


class BooksInitialState extends ReadingPlansState {}

class BooksListLoadedState extends ReadingPlansState {
  final List<Book> books;
  final List<Loan> loans;
  const BooksListLoadedState(this.books, this.loans);

  @override
  List<Object> get props => [books];
}

class BooksListErrorState extends ReadingPlansState {
  final String message;
  const BooksListErrorState( this.message);
}

