import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/domain/repositories/sign_in_repository.dart';
import 'package:leeds_library/presentation/block/user_cubit/user_cubit.dart';
import 'package:leeds_library/presentation/block/user_register/register_event.dart';
import 'package:leeds_library/presentation/block/user_register/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final SignInRepository repository;
  bool rememberMe = false;

  RegisterBloc({required this.repository}) : super(RegisterInitial()) {
    on<FetchRegister>((event, emit) async {
      emit(RegisterLoading());

      try {
        final result = await repository.updateUser(event.user);

        if (result.isSuccess) {
          final userCubit = sl<UserCubit>();
          userCubit.setUser(event.user);
          emit(RegisterSuccess());
        } else {
          emit(RegisterFailure(message: result.error ?? "Unknown error"));
        }
      } catch (e) {
        emit(RegisterFailure(message: "Unexpected error occurred"));
      }
    });



  }
}