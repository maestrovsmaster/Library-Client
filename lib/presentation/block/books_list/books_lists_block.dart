import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/domain/repositories/books_firebase_repository.dart';
import 'books_list_event.dart';
import 'books_lists_state.dart';

class BooksListBloc extends Bloc<BooksListEvent, BooksListState> {
  final BooksFirebaseRepository booksRepository;
  final StreamController<List<Book>> _filteredBooksController = StreamController.broadcast();
  List<Book> _allBooks = [];
  String _currentQuery = '';

  BooksListBloc({required this.booksRepository}) : super(BooksInitialState()) {
    on<LoadBooksEvent>(_onLoadBooks);
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
  }

  Future<void> _onLoadBooks(LoadBooksEvent event, Emitter<BooksListState> emit) async {
    try {
      final booksStream = booksRepository.getBooksStream();
      booksStream.listen((books) {
        _allBooks = books;
        _applyFilter();
      });
      emit(BooksStreamState(_filteredBooksController.stream));
    } catch (e) {
      emit(BooksErrorState("Не вдалося завантажити книги"));
    }
  }

  void _onSearchQueryChanged(SearchQueryChangedEvent event, Emitter<BooksListState> emit) {
    _currentQuery = event.query;
    _applyFilter();
  }

  void _applyFilter() {
    final filteredBooks = _allBooks.where((book) {
      final lowerQuery = _currentQuery.toLowerCase().trim();
      return book.title.toLowerCase().contains(lowerQuery) ||
          book.author.toLowerCase().contains(lowerQuery) ||
          book.barcode.toLowerCase() == lowerQuery;
    }).toList();

    _filteredBooksController.add(filteredBooks);
  }

  @override
  Future<void> close() {
    _filteredBooksController.close();
    return super.close();
  }
}