import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/data/models/loan.dart';
import 'package:leeds_library/domain/repositories/loans_repository.dart';

import 'my_loans_event.dart';
import 'my_loans_state.dart';

class MyLoansListBloc extends Bloc<MyLoansListEvent, MyLoansListState> {
  final LoansRepository repository;

  List<Loan> _allLoans = [];


  MyLoansListBloc({required this.repository}) : super(LoansInitialState()) {
    on<LoadLoansEvent>(_onLoadLoans);

  }

  Future<void> _onLoadLoans(LoadLoansEvent event, Emitter<MyLoansListState> emit) async {
    try {

      final result = await repository.getMyLoans();
      if (result.isSuccess) {
        _allLoans = result.data ?? [];
        emit(LoansListState(_allLoans));
      } else {
        emit(LoansErrorState(result.error ?? "Не вдалося завантажити бронювання"));
      }


    } catch (e) {
      emit(LoansErrorState("Не вдалося завантажити бронювання"));
    }
  }


  @override
  Future<void> close() {
    return super.close();
  }


}