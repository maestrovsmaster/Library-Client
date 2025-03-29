import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/data/models/loan.dart';
import 'package:leeds_library/domain/repositories/loans_repository.dart';
import 'package:leeds_library/domain/repositories/readers_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'create_loan_event.dart';
import 'create_loan_state.dart';

class CreateLoanBloc extends Bloc<CreateLoanEvent, CreateLoanState> {
  final ReadersRepository _repo;
  final LoansRepository loanRepository;

  CreateLoanBloc(this._repo, this.loanRepository) : super(CreateLoanInitial()) {
    on<SearchReaderEvent>(_onSearch,
        transformer: debounceRestartable(const Duration(milliseconds: 400)),);
    on<SelectReaderEvent>(_onSelectReader);
    on<AddLoanEvent>(_onAddLoan);
  }

  Future<void> _onSearch(
      SearchReaderEvent event, Emitter<CreateLoanState> emit) async {
    final query = event.query.trim();

    if (query.length < 3) {
      emit(CreateLoanInitial());
      return;
    }

    emit(CreateLoanLoading());

    try {
      final readers = await _repo.searchByName(query);
      emit(CreateLoanReadersFound(readers));
    } catch (e) {
      emit(CreateLoanFailure("Помилка пошуку читача "));
    }
  }

  Future<void> _onSelectReader(
      SelectReaderEvent event, Emitter<CreateLoanState> emit) async {
    emit(SelectReaderState(event.reader));
  }

  Future<void> _onAddLoan(
      AddLoanEvent event, Emitter<CreateLoanState> emit) async {
    try{
      final loan = Loan(
        book: event.book.toJson(),
        reader: event.reader.toMap(),
        borrowedBy: event.reader.name,
        dateBorrowed: DateTime.now(),
      );
      final result = await loanRepository.createLoan(loan);
      print("result = $result");
      if(result.isSuccess){
        emit(CreateLoanSuccess());
      }else{
        emit(CreateLoanFailure("Помилка бронювання ${result.error}"));
      }
    }catch(e){
      emit(CreateLoanFailure("Помилка бронювання. $e"));
    }

  }


  EventTransformer<E> debounceRestartable<E>(Duration duration) {
    return (events, mapper) =>
        events.debounceTime(duration).switchMap(mapper);
  }
}
