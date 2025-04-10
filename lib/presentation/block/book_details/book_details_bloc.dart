import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/domain/repositories/books_repository.dart';

import 'book_details_event.dart';
import 'book_details_state.dart';

class BookDetailsBloc extends Bloc<BooksDetailsEvent, BookDetailsState> {
  final BooksRepository booksRepository;
  StreamSubscription<Book?>? _subscription;

  BookDetailsBloc({required this.booksRepository}) : super(BookInitialState()) {
    on<LoadBooksEvent>(_onLoadBook);
  }

  Future<void> _onLoadBook(LoadBooksEvent event, Emitter<BookDetailsState> emit) async {
    await emit.forEach<Book?>(
      booksRepository.getBookStreamById(event.bookId),
      onData: (book) {
        if (book != null) {
          return BookLoadedState(book);
        } else {
          return BookNotFoundState();
        }
      },
      onError: (_, __) => BookNotFoundState(), // опціонально
    );
  }


  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
