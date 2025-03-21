import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/data/net/global_interceptor.dart';
import 'package:leeds_library/domain/repositories/books_firebase_repository.dart';
import 'package:leeds_library/domain/repositories/books_repository.dart';
import 'package:leeds_library/domain/repositories/sign_in_repository.dart';
import 'package:leeds_library/presentation/block/add_book/add_book_bloc.dart';
import 'package:leeds_library/presentation/block/barcode_scanner/barcode_scanner_block.dart';
import 'package:leeds_library/presentation/block/books_list/books_lists_block.dart';
import 'package:leeds_library/presentation/block/main_screen/main_screen_block.dart';
import 'package:leeds_library/presentation/block/text_recognize/text_recognize_block.dart';
import 'package:leeds_library/presentation/block/user_cubit/user_cubit.dart';
import 'package:leeds_library/presentation/block/user_google_auth/google_auth_block.dart';
import 'package:leeds_library/presentation/block/user_register/register_block.dart';
import 'package:leeds_library/presentation/block/welcome/welcome_block.dart';


final sl = GetIt.instance;

/// Initialize the dependency injection container.
/// assets - mock data from assets
/// generator - mock data from generator
Future<void> init({String mockType = 'assets'}) async {
  final itemBox = await Hive.openBox<Book>('books');
  sl.registerLazySingleton<Box<Book>>(() => itemBox);

  final firebase = FirebaseFirestore.instance;

  final dio = Dio();
  final authInterceptor = AuthInterceptor();
  sl.registerLazySingleton(() => authInterceptor);
  dio.interceptors.add(authInterceptor);
  dio.options.baseUrl = "http://192.168.0.25:5001/library-541e4/us-central1";
  sl.registerLazySingleton(() => dio);

  sl.registerLazySingleton(() => UserCubit());

  sl.registerLazySingleton(() => SignInRepository(sl<Dio>()));
  sl.registerLazySingleton(() => BooksRepository(sl<Dio>()));

  sl.registerLazySingleton(() => BooksFirebaseRepository(firebase, itemBox));

  sl.registerFactory(() => WelcomeBloc(repository: sl<SignInRepository>(), userCubit: sl<UserCubit>(), authInterceptor: sl<AuthInterceptor>()));

  sl.registerFactory(() => GoogleAuthBloc(sl<AuthInterceptor>(),
      sl<SignInRepository>()));


  sl.registerFactory(() => RegisterBloc(repository:sl<SignInRepository>()));

  sl.registerFactory(()=> BarcodeScannerBloc(booksRepository: sl<BooksRepository>()));
  sl.registerFactory(() => AddBookBloc(sl<BooksRepository>()));
  sl.registerFactory(() => TextRecognizerBloc());


  sl.registerFactory(() => MainScreenBloc(repository: sl<SignInRepository>()));

  sl.registerFactory(() => BooksListBloc(booksRepository: sl<BooksFirebaseRepository>()));
}
