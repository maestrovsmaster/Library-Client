import 'package:equatable/equatable.dart';
import 'package:leeds_library/data/models/book.dart';

abstract class BookDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookInitialState extends BookDetailsState {}

class BookLoadedState extends BookDetailsState {
  final Book book;
  BookLoadedState(this.book);

  @override
  List<Object?> get props => [book];
}

class BookNotFoundState extends BookDetailsState {}
