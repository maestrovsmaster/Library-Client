import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/data/net/global_interceptor.dart';
import 'package:leeds_library/domain/repositories/google_auth_repository.dart';

import 'google_auth_event.dart';
import 'google_auth_state.dart';

class GoogleAuthBloc extends Bloc<GoogleAuthEvent, GoogleAuthState> {
  final AuthInterceptor _authInterceptor;
  final GoogleAuthRepository _authRepository;
  GoogleAuthBloc(this._authInterceptor,
      this._authRepository) : super(GoogleAuthInitial()) {
    on<GoogleSignInEvent>((event, emit) async {
      emit(GoogleAuthLoading());
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        final idToken = await user.getIdToken();
        if (idToken != null) {
          _authInterceptor.updateToken(idToken);
        }

        add(VerifyTokenEvent(idToken!));
      } else {
        emit(GoogleUnauthenticated());
      }
    });

    on<VerifyTokenEvent>((event, emit) async {
      emit(GoogleAuthLoading());
      final appUser = await _authRepository.verifyTokenWithServer(event.idToken);
      if (appUser != null) {
        emit(Authenticated(appUser));
      } else {
        emit(GoogleUnauthenticated());
      }
    });

    on<GoogleLogoutEvent>((event, emit) async {
      await _authRepository.signOut();
      emit(GoogleUnauthenticated());
    });
  }
}