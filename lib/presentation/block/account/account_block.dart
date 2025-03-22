import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/domain/repositories/sign_in_repository.dart';
import 'package:leeds_library/presentation/block/user_cubit/user_cubit.dart';

import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {

  UserCubit userCubit;
  SignInRepository signInRepository;

  AccountBloc({required this.userCubit, required this.signInRepository}) : super(AccountInitialState()) {
    on<FetchAccount>(_fetchAccount);
    on<LogOut>(_logOut);
   // on<LogIn>(_logIn);
  }

  Future<void> _fetchAccount(FetchAccount event, Emitter<AccountState> emit) async {
    emit(AccountLoadingState());
    try {
      final user = await userCubit.state;
      if (user != null) {
        emit(FetchedUserState(user));
      } else {
      emit(AccountErrorState("Не вдалося отримати дані"));
      }
      } catch (e) {
      emit(AccountErrorState("Не вдалося отримати дані"));
    }

  }

  Future<void> _logOut(LogOut event, Emitter<AccountState> emit) async {
    emit(AccountLoadingState());
    try {
      await signInRepository.signOut();
      emit(AccountLoggedOutState());
    } catch (e) {
      emit(AccountErrorState("Не вдалося вийти"));

    }
  }


}