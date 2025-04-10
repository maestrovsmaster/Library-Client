import 'package:equatable/equatable.dart';
import 'package:leeds_library/data/models/book.dart';

abstract class BookDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookInitialState extends BookDetailsState {}

class BookLoadedState extends BookDetailsState {
  final Book book;
  final bool? isBookInReadingPlan;
  BookLoadedState(this.book, this.isBookInReadingPlan);

  BookLoadedState copyWith({
    Book? book,
    bool? isBookInReadingPlan,
  }) {
    return BookLoadedState(
       book ?? this.book,
      isBookInReadingPlan ?? this.isBookInReadingPlan,
    );
  }

  @override
  String toString() =>
      'BookLoadedState(book: $book, isBookInReadingPlan: $isBookInReadingPlan)';

  @override
  List<Object?> get props => [book, isBookInReadingPlan];
}

class BookNotFoundState extends BookDetailsState {}

//isBookInReadingPlan
class IsBookInReadingPlanState extends BookDetailsState {
  final bool? isBookInReadingPlan;
  IsBookInReadingPlanState(this.isBookInReadingPlan);
}


class CreateReadPlanState extends BookDetailsState {}

class CreateReadPlanError extends BookDetailsState {
  final String message;
  CreateReadPlanError(this.message);
}

class DeleteReadPlanState extends BookDetailsState {}

class DeleteReadPlanError extends BookDetailsState {
  final String message;
  DeleteReadPlanError(this.message);
}