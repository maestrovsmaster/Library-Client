import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/presentation/block/account/account_block.dart';
import 'package:leeds_library/presentation/block/account/account_event.dart';
import 'package:leeds_library/presentation/block/account/account_state.dart';
import 'package:leeds_library/presentation/screens/account_screen/user_profile_card.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => sl<AccountBloc>()..add(FetchAccount()),
        child: Scaffold(
            appBar: AppBar(
              title: Text("Аккаунт"),
            ),
            body: BlocBuilder<AccountBloc, AccountState>(builder:
            (context, state) {
              if (state is AccountLoadingState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is FetchedUserState) {
                return UserProfileCard(user: state.user, onLogout: () {

                  print("Logout button pressed");
                  //send logout event for AccountBlock
                  sl<AccountBloc>().add(LogOut());
                });
              } else if (state is AccountLoggedOutState) {
                print("Logged out");
                //return Center(child: Text("Ви вийшли з аккаунту"));

                //кнопка логін, що закриває поточний скрін та веде на логін авторизацію
                return Center(child: ElevatedButton(onPressed: () {
                  Navigator.of(context).pop();
                  //go to welcome
                  Navigator.of(context).pushNamed('/welcome');
                }, child: Text("Вийти")));
              } else if (state is AccountErrorState) {
                return Center(child: Text(state.message));
              }
              return Center(child: Text("Не вдалося отримати дані"));
            }

            )));
  }
}
