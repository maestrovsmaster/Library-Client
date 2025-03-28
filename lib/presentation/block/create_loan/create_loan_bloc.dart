import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/domain/repositories/readers_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'create_loan_event.dart';
import 'create_loan_state.dart';

class CreateLoanBloc extends Bloc<CreateLoanEvent, CreateLoanState> {
  final ReadersRepository _repo;

  CreateLoanBloc(this._repo) : super(CreateLoanInitial()) {
    on<SearchReaderEvent>(_onSearch,
        transformer: debounceRestartable(const Duration(milliseconds: 400)),);
    on<SelectReaderEvent>(_onSelectReader);
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
      emit(CreateLoanFailure("Помилка пошуку читача"));
    }
  }

  Future<void> _onSelectReader(
      SelectReaderEvent event, Emitter<CreateLoanState> emit) async {
    emit(SelectReaderState(event.reader));
  }


  EventTransformer<E> debounceRestartable<E>(Duration duration) {
    return (events, mapper) =>
        events.debounceTime(duration).switchMap(mapper);
  }
}
