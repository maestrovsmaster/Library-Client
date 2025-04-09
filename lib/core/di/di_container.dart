import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/data/net/global_interceptor.dart';
import 'package:leeds_library/domain/repositories/books_repository.dart';
import 'package:leeds_library/domain/repositories/loans_repository.dart';
import 'package:leeds_library/domain/repositories/readers_repository.dart';
import 'package:leeds_library/domain/repositories/review_repository.dart';
import 'package:leeds_library/domain/repositories/sign_in_repository.dart';
import 'package:leeds_library/presentation/block/account/account_block.dart';
import 'package:leeds_library/presentation/block/add_book/add_book_bloc.dart';
import 'package:leeds_library/presentation/block/add_reader/add_reader_bloc.dart';
import 'package:leeds_library/presentation/block/barcode_scanner/barcode_scanner_block.dart';
import 'package:leeds_library/presentation/block/book_details/book_details_bloc.dart';
import 'package:leeds_library/presentation/block/books_list/books_lists_block.dart';
import 'package:leeds_library/presentation/block/create_loan/create_loan_bloc.dart';
import 'package:leeds_library/presentation/block/finder_bloc/finder_bloc.dart';
import 'package:leeds_library/presentation/block/loans_list/loans_list_bloc.dart';
import 'package:leeds_library/presentation/block/main_screen/main_screen_block.dart';
import 'package:leeds_library/presentation/block/reviews/reviews_bloc.dart';
import 'package:leeds_library/presentation/block/text_recognize/text_recognize_block.dart';
import 'package:leeds_library/presentation/block/user_cubit/user_cubit.dart';
import 'package:leeds_library/presentation/block/user_google_auth/google_auth_block.dart';
import 'package:leeds_library/presentation/block/user_register/register_block.dart';
import 'package:leeds_library/presentation/block/welcome/welcome_block.dart';

final sl = GetIt.instance;

/// Initialize the dependency injection container.
/// assets - mock data from assets
/// generator - mock data from generator
Future<void> init(
    {String baseUrl = 'http://192.168.0.25:5001/library-541e4/us-central1',
    String postfix = ''}) async {
  final itemBox = await Hive.openBox<Book>('books');
  sl.registerLazySingleton<Box<Book>>(() => itemBox);

  final firebase = FirebaseFirestore.instance;

  final dio = Dio();
  final authInterceptor = AuthInterceptor()..setPostfix(postfix);

  sl.registerLazySingleton(() => authInterceptor);
  dio.interceptors.add(authInterceptor);
  dio.options.baseUrl =
      baseUrl; //"http://192.168.0.25:5001/library-541e4/us-central1";
  sl.registerLazySingleton(() => dio);

  sl.registerLazySingleton(() => UserCubit());

  sl.registerLazySingleton(() =>
      SignInRepository(sl<Dio>(), sl<UserCubit>(), sl<AuthInterceptor>()));

  sl.registerLazySingleton(
      () => BooksRepository(sl<Dio>(), firebase, itemBox, postfix: postfix));
  sl.registerLazySingleton(
      () => ReadersRepository(sl<Dio>(), firebase, postfix: postfix));
  sl.registerLazySingleton(
      () => LoansRepository(sl<Dio>(), firebase, postfix: postfix));
  sl.registerLazySingleton(
      () => ReviewsRepository(sl<Dio>(), firebase, postfix: postfix));

  sl.registerFactory(() => WelcomeBloc(
      repository: sl<SignInRepository>(),
      userCubit: sl<UserCubit>(),
      authInterceptor: sl<AuthInterceptor>()));

  sl.registerFactory(
      () => GoogleAuthBloc(sl<AuthInterceptor>(), sl<SignInRepository>()));

  sl.registerFactory(() => RegisterBloc(repository: sl<SignInRepository>()));

  sl.registerFactory(() => AccountBloc(
      userCubit: sl<UserCubit>(), signInRepository: sl<SignInRepository>()));

  sl.registerFactory(
      () => BarcodeScannerBloc(booksRepository: sl<BooksRepository>()));
  sl.registerFactory(() => AddBookBloc(sl<BooksRepository>()));
  sl.registerFactory(() => TextRecognizerBloc());

  sl.registerFactory(() => MainScreenBloc(repository: sl<SignInRepository>()));

  sl.registerFactory(() => BooksListBloc(
        booksRepository: sl<BooksRepository>(),
      ));

  sl.registerFactory(() => FinderBloc(
      booksRepository: sl<BooksRepository>(),
      loansRepository: sl<LoansRepository>()));

  sl.registerFactory(() => AddReaderBloc(sl<ReadersRepository>()));

  sl.registerFactory(
      () => CreateLoanBloc(sl<ReadersRepository>(), sl<LoansRepository>()));

  sl.registerFactory(() => LoansListBloc(repository: sl<LoansRepository>()));

  sl.registerFactory(
      () => BookDetailsBloc(booksRepository: sl<BooksRepository>()));

  sl.registerFactory(() => ReviewsBloc(repository: sl<ReviewsRepository>(), userCubit: sl<UserCubit>()));
}
