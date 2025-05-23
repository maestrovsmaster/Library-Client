import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/core/theme/app_colors.dart';
import 'package:leeds_library/presentation/block/user_google_auth/google_auth_block.dart';
import 'package:leeds_library/presentation/block/user_google_auth/google_auth_event.dart';
import 'package:leeds_library/presentation/block/user_google_auth/google_auth_state.dart';
import 'package:leeds_library/presentation/navigation/app_router.dart';
import 'package:leeds_library/presentation/widgets/google_sign_in_button.dart';


class GoogleSignInScreen extends StatelessWidget {
  const GoogleSignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GoogleAuthBloc>(),
      child: Scaffold(
        appBar: AppBar(title: Text("Sign In")),
        body: Center(
          child: BlocConsumer<GoogleAuthBloc, GoogleAuthState>(
            listener: (context, state) {
              if (state is Authenticated) {
                print("Authenticated with user: ${state.user}");

                context.pushReplacement(AppRoutes.main);
              }
              if (state is AuthenticatedButNotCompleted) {
                print("Authenticated with user: ${state.user}");

                context.pushReplacement(AppRoutes.register, extra: state.user);
              }
            },
            builder: (context, state) {
              if (state is GoogleAuthLoading) {
                return CircularProgressIndicator();
              } if(state is AuthenticatedButNotCompleted){
                return Text("Authenticated with user: ${state.user}");
              }
              return /*ElevatedButton(
                onPressed: () {
                  context.read<GoogleAuthBloc>().add(GoogleSignInEvent());
                },
                child: Text("Sign in with Google"),
              );*/

                GoogleSignInButton(
                  onPressed: () {
                    context.read<GoogleAuthBloc>().add(GoogleSignInEvent());
                  },
                );
            },
          ),
        ),
      ),
    );
  }
}
