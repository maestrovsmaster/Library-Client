import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/presentation/block/main_screen/main_screen_block.dart';
import 'package:leeds_library/presentation/block/main_screen/main_screen_event.dart';
import 'package:leeds_library/presentation/block/main_screen/main_screen_state.dart';
import 'package:leeds_library/presentation/navigation/app_router.dart';
import 'package:leeds_library/presentation/screens/account_screen/account_screen.dart';
import 'package:leeds_library/presentation/screens/barcode_scanner_screen/barcode_scanner_screen.dart';
import 'package:leeds_library/presentation/screens/books_list/books_list_screen.dart';
import 'package:leeds_library/presentation/screens/finder_screen/finder_screen.dart';
import 'package:leeds_library/presentation/screens/loans_list_screen/loans_list_screen.dart';
import 'package:leeds_library/presentation/screens/loans_my_screen/my_loans_widget.dart';
import 'package:leeds_library/presentation/screens/placeholder_screen/placeholder_screen.dart';
import 'package:leeds_library/presentation/screens/reading_plans_screen/reading_plans_screen.dart';
import 'package:leeds_library/presentation/screens/text_recognize_screen.dart';
import 'package:leeds_library/presentation/widgets/confirm_dialog.dart';
import 'package:leeds_library/presentation/widgets/notifications_widget.dart';


import 'main_screen_bottom_navigation.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => sl<MainScreenBloc>(),
        child: BlocListener<MainScreenBloc, MainScreenState>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              context.go(AppRoutes.welcome);
            }
          },
          child: BlocBuilder<MainScreenBloc, MainScreenState>(
            builder: (context, state) {
              final bloc = BlocProvider.of<MainScreenBloc>(context);

              if (state is MainScreenInitial) {
                return Scaffold(

                    body: _getSelectedScreen(state.selectedIndex),
                    bottomNavigationBar: MainScreenBottomNavigationBar(
                      currentIndex: state.selectedIndex,
                      onTap: (index) {
                        bloc.add(SelectScreen(index));
                      },
                    ));
              } else {
                return  Container();
              }
            },
          ),
        ));
  }



  Widget _getSelectedScreen(int index) {
    switch (index) {
      case 0:
        return  FinderScreen(); // TextRecognizeScreen();
      case 1:
        return  BooksListScreen();//PlaceholderScreen(title: translate('tab_main')); //const CollectionsListScreen();
      case 2:
        return LoansListScreen();
      case 3:
        return ReadingPlansScreen();
      case 4:
        return AccountScreen();
      default:
        return Container();
    }
  }

  void _showLogoutDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          title:  translate('logout_title'),
          message: translate('logout_message'),
          confirmText: translate('confirm'),
          cancelText: translate('cancel'),
          onConfirm: onConfirm,
        );
      },
    );
  }

}
