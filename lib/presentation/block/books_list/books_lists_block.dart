import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/domain/repositories/books_firebase_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'books_list_event.dart';
import 'books_lists_state.dart';

class BooksListBloc extends Bloc<BooksListEvent, BooksListState> {
  final BooksFirebaseRepository booksRepository;
  final _filteredBooksController = BehaviorSubject<List<Book>>();

  List<Book> _allBooks = [];
  String _currentQuery = '';

  Stream<List<Book>> get filteredBooksStream => _filteredBooksController.stream;

  BooksListBloc({required this.booksRepository}) : super(BooksInitialState()) {
    on<LoadBooksEvent>(_onLoadBooks);
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
  }

  Future<void> _onLoadBooks(LoadBooksEvent event, Emitter<BooksListState> emit) async {
    try {
      if (state is BooksStreamState) return;

      emit(BooksStreamState(filteredBooksStream));

      booksRepository.booksStream.listen((books) {
        _allBooks = books;
        _applyFilter();
      });
    } catch (e) {
      emit(BooksErrorState("Не вдалося завантажити книги"));
    }
  }

  void _onSearchQueryChanged(SearchQueryChangedEvent event, Emitter<BooksListState> emit) {
    _currentQuery = event.query;
    _applyFilter();
  }

  void _applyFilter() {
    final query = _currentQuery.toLowerCase().trim();

    final filtered = query.isEmpty
        ? _allBooks
        : _allBooks.where((book) {
      return book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query) ||
          book.barcode.toLowerCase() == query;
    }).toList();

    _filteredBooksController.add(filtered);
  }

  @override
  Future<void> close() {
    print("Destroying BooksListBloc");
    _filteredBooksController.close();
    return super.close();
  }
}
