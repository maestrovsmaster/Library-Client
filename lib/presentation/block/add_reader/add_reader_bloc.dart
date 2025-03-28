import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/data/models/reader.dart';
import 'package:leeds_library/domain/repositories/readers_repository.dart';

import 'add_reader_event.dart';
import 'add_reader_state.dart';

class AddReaderBloc extends Bloc<AddReaderEvent, AddReaderState> {
  final ReadersRepository _repository;

  AddReaderBloc(this._repository) : super(AddReaderInitial()) {
    on<SubmitReaderEvent>(_onSubmit);
  }

  Future<void> _onSubmit(
      SubmitReaderEvent event, Emitter<AddReaderState> emit) async {
    emit(AddReaderLoading());

    try {
      final reader = Reader(
        id: '', // буде згенеровано Firestore
        email: event.email,
        name: event.name,
        phoneNumber: event.phoneNumber,
        phoneNumberAlt: event.phoneNumberAlt,
      );

      final result = await _repository.createReader(reader);

      if (result.isSuccess) {
        final newReader = result.data;
        if (newReader != null) {
        emit(AddReaderSuccess(newReader));
        } else {
          emit(AddReaderFailure("Помилка створення"));
        }
      } else {
        emit(AddReaderFailure(result.error ?? "Помилка створення"));
      }
    } catch (e) {
      emit(AddReaderFailure("Невідома помилка: $e"));
    }
  }
}
