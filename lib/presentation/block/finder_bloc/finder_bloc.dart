import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/domain/repositories/books_firebase_repository.dart';
import 'package:leeds_library/domain/repositories/books_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'finder_event.dart';
import 'finser_state.dart';

class FinderBloc extends Bloc<FinderEvent, FinderState> {
  final BooksFirebaseRepository booksFirebaseRepository;
  final BooksRepository booksRepository;
  final _filteredBooksController = BehaviorSubject<List<Book>>();

  List<Book> _allBooks = [];
  String _currentQuery = '';

  Stream<List<Book>> get filteredBooksStream => _filteredBooksController.stream;

  FinderBloc({required this.booksRepository, required this.booksFirebaseRepository}) : super(BooksInitialState()) {
    on<FinderLoadBooksEvent>(_onLoadBooks);
    on<FinderSearchQueryChangedEvent>(_onSearchQueryChanged);
  }

  Future<void> _onLoadBooks(FinderLoadBooksEvent event, Emitter<FinderState> emit) async {
    try {
      if (state is FinderBooksListState) return;

      emit(FinderBooksListState(filteredBooksStream));

      booksFirebaseRepository.booksStream.listen((books) {
        _allBooks = books;
        _applyFilter();
      });
    } catch (e) {
      emit(BooksErrorState("Не вдалося завантажити книги"));
    }
  }



  void _onSearchQueryChanged(FinderSearchQueryChangedEvent event, Emitter<FinderState> emit) {
    _currentQuery = event.query;
    _applyFilter();
  }

  void _applyFilter() {

    if(_currentQuery.isEmpty || _currentQuery.length < 3){
      _filteredBooksController.add([]);
      return;
    }

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



