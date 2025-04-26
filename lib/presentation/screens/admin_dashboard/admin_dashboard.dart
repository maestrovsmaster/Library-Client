import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/core/theme/app_colors.dart';
import 'package:leeds_library/presentation/block/admin_dashboard_bloc/admin_dashboard_bloc.dart';
import 'package:leeds_library/presentation/navigation/app_router.dart';
import 'package:leeds_library/presentation/screens/account_screen/account_screen.dart';
import 'package:leeds_library/presentation/screens/books_list/books_list_screen.dart';
import 'package:leeds_library/presentation/screens/finder_screen/finder_screen.dart';
import 'package:leeds_library/presentation/screens/loans_list_screen/loans_list_screen.dart';
import 'package:leeds_library/presentation/screens/reading_plans_screen/reading_plans_screen.dart';

import 'admin_navigation.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => sl<AdminDashboardBloc>(),
        child: BlocListener<AdminDashboardBloc, AdminDashboardState>(
          listener: (context, state) {

          },
          child: BlocBuilder<AdminDashboardBloc, AdminDashboardState>(
            builder: (context, state) {
              final bloc = BlocProvider.of<AdminDashboardBloc>(context);

              if (state is AdminDashboardInitial) {
                return WillPopScope(
                    onWillPop: () async {

                      context.pushReplacement(AppRoutes.main);
                  return false;
                },
                    child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: AppColors.yellow,
                      title: const Text("Admin", style: TextStyle(color: Colors.black)),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          context.pushReplacement(AppRoutes.main);
                        },
                      ),
                    ),


                    body: _getSelectedScreen(state.selectedIndex),
                    bottomNavigationBar: AdminBottomNavigationBar(
                      currentIndex: state.selectedIndex,
                      onTap: (index) {
                        bloc.add(SelectScreen(index));
                      },
                    )));
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
      //case 3:
      //  return ReadingPlansScreen();
     // case 4:
      //  return AccountScreen();
      default:
        return Container();
    }
  }



}
