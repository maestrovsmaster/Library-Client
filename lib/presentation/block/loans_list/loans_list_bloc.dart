import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/data/models/loan.dart';
import 'package:leeds_library/domain/repositories/loans_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'loans_list_event.dart';
import 'loans_list_state.dart';

class LoansListBloc extends Bloc<LoansListEvent, LoansListState> {
  final LoansRepository repository;
  final _filteredBooksController = BehaviorSubject<List<Loan>>();

  List<Loan> _allLoans = [];
  String _currentQuery = '';

  Stream<List<Loan>> get filteredLoansStream => _filteredBooksController.stream;

  LoansListBloc({required this.repository}) : super(LoansInitialState()) {
    on<LoadLoansEvent>(_onLoadBooks);
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
  }

  Future<void> _onLoadBooks(LoadLoansEvent event, Emitter<LoansListState> emit) async {
    try {
      if (state is LoansStreamState) return;

      emit(LoansStreamState(filteredLoansStream));

      repository.loansStream.listen((books) {
        _allLoans = books;
        _applyFilter();
      });
    } catch (e) {
      emit(LoansErrorState("Не вдалося завантажити бронювання"));
    }
  }

  void _onSearchQueryChanged(SearchQueryChangedEvent event, Emitter<LoansListState> emit) {
    _currentQuery = event.query;
    _applyFilter();
  }

  void _applyFilter() {
    final query = _currentQuery.toLowerCase().trim();

   /* final filtered = query.isEmpty
        ? _allLoans
        : _allLoans.where((loan) {
      return loan.title.toLowerCase().contains(query) ||
          loan.author.toLowerCase().contains(query) ||
          loan.barcode.toLowerCase() == query;
    }).toList();

    _filteredBooksController.add(filtered);*/
    _filteredBooksController.add(_allLoans);
  }

  @override
  Future<void> close() {
    print("Destroying BooksListBloc");
    _filteredBooksController.close();
    return super.close();
  }


}