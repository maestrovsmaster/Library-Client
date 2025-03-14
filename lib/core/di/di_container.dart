import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:leeds_library/data/net/global_interceptor.dart';
import 'package:leeds_library/domain/repositories/books_repository.dart';
import 'package:leeds_library/domain/repositories/sign_in_repository.dart';
import 'package:leeds_library/presentation/block/barcode_scanner/barcode_scanner_block.dart';
import 'package:leeds_library/presentation/block/main_screen/main_screen_block.dart';
import 'package:leeds_library/presentation/block/user_cubit/user_cubit.dart';
import 'package:leeds_library/presentation/block/user_google_auth/google_auth_block.dart';
import 'package:leeds_library/presentation/block/user_register/register_block.dart';
import 'package:leeds_library/presentation/block/welcome/welcome_block.dart';


final sl = GetIt.instance;

/// Initialize the dependency injection container.
/// assets - mock data from assets
/// generator - mock data from generator
Future<void> init({String mockType = 'assets'}) async {
 // final itemBox = await Hive.openBox<ItemModel>('item_model_box');
 // sl.registerLazySingleton<Box<ItemModel>>(() => itemBox);

  final dio = Dio();
  final authInterceptor = AuthInterceptor();
  sl.registerLazySingleton(() => authInterceptor);
  dio.interceptors.add(authInterceptor);
  dio.options.baseUrl = "http://192.168.0.25:5001/library-541e4/us-central1";
  sl.registerLazySingleton(() => dio);

  sl.registerLazySingleton(() => UserCubit());

  sl.registerFactory(() => WelcomeBloc(repository: sl<SignInRepository>(), userCubit: sl<UserCubit>(), authInterceptor: sl<AuthInterceptor>()));

  sl.registerLazySingleton(() => SignInRepository(sl<Dio>()));
  sl.registerLazySingleton(() => BooksRepository(sl<Dio>()));

  sl.registerLazySingleton(() => GoogleAuthBloc(sl<AuthInterceptor>(),
      sl<SignInRepository>()));


  sl.registerLazySingleton(() => RegisterBloc(repository:sl<SignInRepository>()));

  sl.registerFactory(()=> BarcodeScannerBloc(booksRepository: sl<BooksRepository>()));



  sl.registerFactory(() => MainScreenBloc(repository: sl<SignInRepository>()));
}
