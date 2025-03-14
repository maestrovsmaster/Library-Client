import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/data/net/global_interceptor.dart';
import 'package:leeds_library/domain/repositories/sign_in_repository.dart';
import 'package:leeds_library/presentation/block/user_cubit/user_cubit.dart';

import 'welcome_event.dart';
import 'welcome_state.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  final SignInRepository repository;
  final UserCubit userCubit;
  final AuthInterceptor authInterceptor;

  WelcomeBloc({required this.repository, required this.userCubit, required this.authInterceptor}) : super(WelcomeInitial()) {
    on<CheckAuthStatus>((event, emit) async {
      print("on<CheckAuthStatus>");
      emit(WelcomeChecking());

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(WelcomeUnauthenticated());
        return;
      }
      final idToken = await user.getIdToken();
      if (idToken != null) {
        authInterceptor.updateToken(idToken); //!!!! add google token to header
      }
      print("on<CheckAuthStatus> 2");
      final result = await repository.verifyTokenWithServer();
      if (result.isSuccess) {
        final appUser = result.data;// final appUser = FirebaseAuth.instance.currentUser;
        print("Authentificated user welcome: ${appUser?.name}");
        if(appUser != null ) {
          if ( appUser.name.isNotEmpty) {
            print("Authentificated user with name: ${appUser.name}");
            userCubit.setUser(result.data!);
            emit(WelcomeAuthenticated());
          } else {
            emit(UserNotCompleted(appUser));
          }
        }else {
          emit(WelcomeUnauthenticated());
        }
      } else {
        emit(WelcomeUnauthenticated());
      }
    });
  }
}

