import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/domain/repositories/sign_in_repository.dart';

import 'welcome_event.dart';
import 'welcome_state.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  final SignInRepository repository;

  WelcomeBloc({required this.repository}) : super(WelcomeInitial()) {
    on<CheckAuthStatus>((event, emit) async {
      emit(WelcomeChecking());

      final bool isLogged = false;//await repository.getLoggedIn();

      if (isLogged) {
        emit(WelcomeAuthenticated());
      } else {
        emit(WelcomeUnauthenticated());
      }
    });
  }
}
