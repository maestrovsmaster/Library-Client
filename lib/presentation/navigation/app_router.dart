import 'package:go_router/go_router.dart';
import 'package:leeds_library/data/models/app_user.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/presentation/screens/add_book_screen/add_book_screen.dart';
import 'package:leeds_library/presentation/screens/add_reader_screen/add_reader_screen.dart';
import 'package:leeds_library/presentation/screens/book_details/book_details_screen.dart';
import 'package:leeds_library/presentation/screens/create_loan_screen/create_loan_screen.dart';
import 'package:leeds_library/presentation/screens/main_screen/main_screen.dart';
import 'package:leeds_library/presentation/screens/register_user_screen/register_screen.dart';
import 'package:leeds_library/presentation/screens/reviews_screen/reviews_screen.dart';
import 'package:leeds_library/presentation/screens/sign_in_google_screen/google_sign_in_screen.dart';
import 'package:leeds_library/presentation/screens/welcome_screen/welcome_screen.dart';


import 'custom_transitions.dart';

class AppRoutes {
  static const String welcome = '/welcome';
  static const String googleSignIn = '/googleSignIn';
  static const String register = '/register';
  static const String main = '/main';
  static const String bookDetails = '/bookDetails';
  static const String addBook = '/addBook';
  static const String addReader = '/addReader';
  static const String createLoan = '/createLoan';
  static const String reviews = '/reviews';
  static const String readingPlans = '/readingPlans';
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

      GoRoute(
          path: AppRoutes.addBook,
          pageBuilder: (context, state) {
            final barcode = state.extra as String?;
            return  CustomTransitionPage(
              child: AddBookScreen(barcode: barcode),
              transitionsBuilder: slideTransition,
            );
          }),

      GoRoute(
          path: AppRoutes.addReader,
          pageBuilder: (context, state) {
            final name = state.extra as String?;
            return  CustomTransitionPage(
              child: AddReaderScreen(name: name),
              transitionsBuilder: slideTransition,
            );
          }),

      GoRoute(
          path: AppRoutes.createLoan,
          pageBuilder: (context, state) {
            final book = state.extra as Book?;
            return  CustomTransitionPage(
              child: CreateLoanScreen(book: book!),
              transitionsBuilder: slideTransition,
            );
          }),

      GoRoute(
          path: AppRoutes.bookDetails,
          pageBuilder: (context, state) {
            final book = state.extra as Book?;
            return  CustomTransitionPage(
              child: BookDetailsScreen(book: book!),
              transitionsBuilder: slideTransition,
            );
          }),

      GoRoute(
          path: AppRoutes.reviews,
          pageBuilder: (context, state) {
            final book = state.extra as Book?;
            return  CustomTransitionPage(
              child: ReviewsList(book: book!),
              transitionsBuilder: slideTransition,
            );
          }),



    ],
  );

  GoRouter get router => _router;
}
