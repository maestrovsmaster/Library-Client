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

class IsBookInReadingPlanEvent extends BooksDetailsEvent {
  final String bookId;
  const IsBookInReadingPlanEvent(this.bookId);
  @override
  List<Object> get props => [bookId];
}

class CreateReadPlanEvent extends BooksDetailsEvent {
  final String bookId;
  const CreateReadPlanEvent(this.bookId, );
  @override
  List<Object> get props => [bookId, ];
}

class DeleteReadPlanEvent extends BooksDetailsEvent {
  final String bookId;

  const DeleteReadPlanEvent(this.bookId,);

  @override
  List<Object> get props => [bookId,];
}



