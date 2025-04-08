import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/domain/repositories/books_repository.dart';
import 'package:leeds_library/domain/repositories/loans_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'finder_event.dart';
import 'finser_state.dart';

class FinderBloc extends Bloc<FinderEvent, FinderState> {
  final BooksRepository booksRepository;
  final _filteredBooksController = BehaviorSubject<List<Book>>();
  final LoansRepository loansRepository;

  List<Book> _allBooks = [];
  String _currentQuery = '';

  Stream<List<Book>> get filteredBooksStream => _filteredBooksController.stream;

  FinderBloc({required this.booksRepository, required this.loansRepository}) : super(BooksInitialState()) {
    print("ADSFSDFSFSDFSDFSDfsdf ==============================================================FinderBlocFinderBlocFinderBlocFinderBlocFinderBlocFinderBlocFinderBloc");
    on<FinderLoadBooksEvent>(_onLoadBooks);
    on<FinderSearchQueryChangedEvent>(_onSearchQueryChanged);
    on<ReturnBookEventEvent>(_onReturnBook);
  }

  Future<void> _onLoadBooks(FinderLoadBooksEvent event, Emitter<FinderState> emit) async {
    print("ADSFSDFSFSDFSDFSDfsdf _onLoadBooks");
    try {
      print("ADSFSDFSFSDFSDFSDfsdf ??????????11");
      if (state is FinderBooksListState) return;
      print("ADSFSDFSFSDFSDFSDfsdf ??????????22");
      emit(FinderBooksListState(filteredBooksStream));

      booksRepository.booksStream.listen((books) {
        _allBooks = books;
        print("ADSFSDFSFSDFSDFSDfsdf ?????????? books $books");
        _applyFilter();
      });

    } catch (e) {
      emit(BooksErrorState("Не вдалося завантажити книги"));
    }
  }



  void _onSearchQueryChanged(FinderSearchQueryChangedEvent event, Emitter<FinderState> emit) {

    _currentQuery = event.query;
    print("ADSFSDFSFSDFSDFSDfsdf event.query=$_currentQuery");
    _applyFilter();
  }

  void _applyFilter() {

    if(_currentQuery.isEmpty || _currentQuery.length < 3){
      _filteredBooksController.add([]);
      return;
    }

    final query = _currentQuery.toLowerCase().trim();
    print("ADSFSDFSFSDFSDFSDfsdf_applyFilter event._allBooks=$_allBooks");
    print("ADSFSDFSFSDFSDFSDfsdf_applyFilter event.query=$query");
    final filtered = query.isEmpty
        ? _allBooks
        : _allBooks.where((book) {
      return book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query) ||
          book.barcode.toLowerCase() == query;
    }).toList();
    print("_currentQuery22 event.filtered=$filtered");
    _filteredBooksController.add(filtered);
  }
  
  Future<void> _onReturnBook(ReturnBookEventEvent event, Emitter<FinderState> emit) async {
    try {
      final book = event.book;
      final loan = await loansRepository.closeLoan(bookId: book.id);
      emit(SuccessReturnBookState());
    }catch(e){
      emit(BooksErrorState("Не вдалося повернути книгу"));
    }
  }

  @override
  Future<void> close() {
    print("Destroying BooksListBloc");
    _filteredBooksController.close();
    return super.close();
  }


}



