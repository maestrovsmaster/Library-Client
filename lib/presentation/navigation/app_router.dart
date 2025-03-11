import 'package:go_router/go_router.dart';
import 'package:leeds_library/data/models/app_user.dart';
import 'package:leeds_library/presentation/screens/main_screen/main_screen.dart';
import 'package:leeds_library/presentation/screens/register_user_screen/register_screen.dart';
import 'package:leeds_library/presentation/screens/sign_in_google_screen/google_sign_in_screen.dart';
import 'package:leeds_library/presentation/screens/welcome_screen/welcome_screen.dart';


import 'custom_transitions.dart';

class AppRoutes {
  static const String welcome = '/welcome';
  static const String googleSignIn = '/googleSignIn';
  static const String register = '/register';
  static const String main = '/main';
  static const String details = '/details';
}

class AppRouter {
  final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.welcome,
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
          path: AppRoutes.googleSignIn,
          pageBuilder: (context, state) {
            return  CustomTransitionPage(
              child: GoogleSignInScreen(),
              transitionsBuilder: slideTransition,
            );
          }),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) {
          final user = state.extra as AppUser;
          return RegisterScreen(user: user);
        },
      ),

      GoRoute(
          path: AppRoutes.main,
          pageBuilder: (context, state) {
            return const CustomTransitionPage(
              child: MainScreen(),
              transitionsBuilder: slideTransition,
            );
          }),
      /*GoRoute(
        path: AppRoutes.details,
        pageBuilder: (context, state) {
          final itemId = state.extra as String;
          return CustomTransitionPage(
            child: BottleDetailsScreen(itemId: itemId),
            transitionsBuilder: slideTransition,
          );
        },
      ),*/
    ],
  );

  GoRouter get router => _router;
}
