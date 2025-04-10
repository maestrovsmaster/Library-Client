import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/domain/repositories/books_repository.dart';
import 'package:leeds_library/presentation/block/user_cubit/user_cubit.dart';

import 'book_details_event.dart';
import 'book_details_state.dart';

class BookDetailsBloc extends Bloc<BooksDetailsEvent, BookDetailsState> {
  final BooksRepository booksRepository;
  StreamSubscription<Book?>? _subscription;

  BookDetailsBloc({required this.booksRepository}) : super(BookInitialState()) {
    on<LoadBooksEvent>(_onLoadBook);
    on<CreateReadPlanEvent>(_onCreateReadPlan);
    on<DeleteReadPlanEvent>(_onDeleteReadPlan);
    on<IsBookInReadingPlanEvent>(_onIsBookInReadingPlan);

  }

  Future<void> _onLoadBook(LoadBooksEvent event, Emitter<BookDetailsState> emit) async {
    await emit.forEach<Book?>(
      booksRepository.getBookStreamById(event.bookId),
      onData: (book) {
        if (book != null) {
          return BookLoadedState(book,null);
        } else {
          return BookNotFoundState();
        }
      },
      onError: (_, __) => BookNotFoundState(),
    );
  }

  Future<void> _onCreateReadPlan(CreateReadPlanEvent event, Emitter<BookDetailsState> emit) async {
    final userCubit = sl<UserCubit>();
    final me = userCubit.state;
    if(me == null){
      emit(CreateReadPlanError("Ви не авторизовані"));
      return;
    }
    final result = await booksRepository.createReadPlan(event.bookId, me.userId);
    if(result.isSuccess){
      emit(CreateReadPlanState());
    }
  }

  Future<void> _onDeleteReadPlan(DeleteReadPlanEvent event, Emitter<BookDetailsState> emit) async {
    final userCubit = sl<UserCubit>();
    final me = userCubit.state;
    if(me == null) {
      emit(DeleteReadPlanError("Ви не авторизовані"));
      return;
    }
    final result = await booksRepository.deleteReadingPlan(event.bookId, me.userId);
    if(result.isSuccess){
      emit(DeleteReadPlanState());
    }
  }

  Future<void> _onIsBookInReadingPlan(IsBookInReadingPlanEvent event, Emitter<BookDetailsState> emit) async {

    final userCubit = sl<UserCubit>();
    final me = userCubit.state;
    if(me == null) {
      emit(IsBookInReadingPlanState(false));
      return;
    }
    final result = await booksRepository.isBookInReadingPlan(event.bookId, me.userId);


    final currentState = state;
    if (currentState is BookLoadedState) {
      final isInPlan = result.isSuccess ? result.data  : false;
      emit(currentState.copyWith(isBookInReadingPlan: isInPlan));
    }
  }


  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
