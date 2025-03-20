import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/data/net/global_interceptor.dart';
import 'package:leeds_library/domain/repositories/sign_in_repository.dart';

import 'google_auth_event.dart';
import 'google_auth_state.dart';

class GoogleAuthBloc extends Bloc<GoogleAuthEvent, GoogleAuthState> {
  final AuthInterceptor _authInterceptor;
  final SignInRepository _authRepository;
  GoogleAuthBloc(this._authInterceptor,
      this._authRepository) : super(GoogleAuthInitial()) {
    on<GoogleSignInEvent>((event, emit) async {
      emit(GoogleAuthLoading());
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        final idToken = await user.getIdToken();
        if (idToken != null) {
          _authInterceptor.updateToken(idToken); //!!!! add google token to header
        }

        add(VerifyTokenEvent(idToken!));
      } else {
        emit(GoogleUnauthenticated());
      }
    });

    on<VerifyTokenEvent>((event, emit) async {
      emit(GoogleAuthLoading());
      final result = await _authRepository.verifyTokenWithServer();
      if (result.isSuccess) {
        print("AppUser isSuccess");
        if (result.data != null) {
          final appUser = result.data!;
          print("================= AppUser isSuccess $appUser");
          if(appUser.name != null && appUser.name.isNotEmpty) {
            emit(Authenticated(result.data!));
          }else{
            emit(AuthenticatedButNotCompleted(result.data!));
          }
        } else {
          emit(GoogleUnauthenticated());
        }
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