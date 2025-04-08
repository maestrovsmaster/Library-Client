import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/domain/repositories/books_repository.dart';

import 'book_details_event.dart';
import 'book_details_state.dart';

class BookDetailsBloc extends Bloc<BooksDetailsEvent, BookDetailsState> {
  final BooksRepository booksRepository;

  BookDetailsBloc({required this.booksRepository}) : super(BookInitialState()) {

  }


}