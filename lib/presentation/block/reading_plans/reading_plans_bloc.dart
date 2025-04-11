import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/domain/repositories/books_repository.dart';
import 'package:leeds_library/presentation/block/user_cubit/user_cubit.dart';

import 'reading_plans_event.dart';
import 'reading_plans_state.dart';


class ReadingPlansBloc extends Bloc<ReadingPlansEvent, ReadingPlansState> {
  final BooksRepository booksRepository;




  ReadingPlansBloc({required this.booksRepository}) : super(BooksInitialState()) {

    on<LoadPlansEvent>(_onLoadPlans);
  }


  Future<void> _onLoadPlans(LoadPlansEvent event, Emitter<ReadingPlansState> emit) async {
    final userCubit = sl<UserCubit>();
    final me = userCubit.state;
    if (me == null) return;

    try {
      final stream = booksRepository.myReadingPlanBooksStream(me.userId);

      await emit.forEach<List<Book>>(
        stream,
        onData: (filteredBooks) => BooksListLoadedState(filteredBooks),
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