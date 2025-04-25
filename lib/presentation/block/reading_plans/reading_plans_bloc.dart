import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/data/models/loan.dart';
import 'package:leeds_library/domain/repositories/books_repository.dart';
import 'package:leeds_library/domain/repositories/loans_repository.dart';
import 'package:leeds_library/presentation/block/user_cubit/user_cubit.dart';

import 'reading_plans_event.dart';
import 'reading_plans_state.dart';


class ReadingPlansBloc extends Bloc<ReadingPlansEvent, ReadingPlansState> {
  final BooksRepository booksRepository;
  final LoansRepository repository;

  List<Loan> _allLoans = [];



  ReadingPlansBloc({required this.booksRepository, required this.repository}) : super(BooksInitialState()) {

    on<LoadPlansEvent>(_onLoadPlans);
  }


  Future<void> _onLoadPlans(LoadPlansEvent event, Emitter<ReadingPlansState> emit) async {
    final userCubit = sl<UserCubit>();
    final me = userCubit.state;
    if (me == null) return;

    try {

      final result = await repository.getMyLoans();
      if (result.isSuccess) {
        _allLoans = result.data ?? [];
        //emit(LoansListState(_allLoans));
      } else {
       // emit(LoansErrorState(result.error ?? "Не вдалося завантажити бронювання"));
        _allLoans = [];
      }
      final stream = booksRepository.myReadingPlanBooksStream(me.userId);

      await emit.forEach<List<Book>>(
        stream,
        onData: (filteredBooks) => BooksListLoadedState(filteredBooks, _allLoans),
        onError: (_, __) => BooksListErrorState("Помилка завантаження даних" ),
      );
    } catch (e) {
      emit(BooksListErrorState("Помилка завантаження даних" ));
    }
  }


  @override
  Future<void> close() {
    return super.close();
  }

}