import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:leeds_library/data/net/global_interceptor.dart';
import 'package:leeds_library/domain/repositories/google_auth_repository.dart';
import 'package:leeds_library/domain/repositories/sign_in_repository.dart';
import 'package:leeds_library/presentation/block/main_screen/main_screen_block.dart';
import 'package:leeds_library/presentation/block/user_cubit/user_cubit.dart';
import 'package:leeds_library/presentation/block/user_google_auth/google_auth_block.dart';
import 'package:leeds_library/presentation/block/user_register/register_block.dart';
import 'package:leeds_library/presentation/block/welcome/welcome_block.dart';
/*import 'package:leeds_library/data/datasource/mock_collection_datasource.dart';
import 'package:leeds_library/data/datasource/mock_from_assets_collection_data_source.dart';
import 'package:leeds_library/data/datasource/mock_from_generator_collection_data_source.dart';
import 'package:leeds_library/data/models/item_model.dart';
import 'package:leeds_library/domain/repositories/collection_repository.dart';
import 'package:leeds_library/domain/repositories/local_collection_repository.dart';
import 'package:leeds_library/domain/repositories/sign_in_repository.dart';
import 'package:leeds_library/presentation/bloc/auth/auth_block.dart';
import 'package:leeds_library/presentation/bloc/bottle_details/bottle_details_block.dart';
import 'package:leeds_library/presentation/bloc/collections_list/collections_list_block.dart';
import 'package:leeds_library/presentation/bloc/collections_list/collections_list_event.dart';
import 'package:leeds_library/presentation/bloc/main_screen/main_screen_block.dart';
import 'package:leeds_library/presentation/bloc/sign_in/sign_in_block.dart';
import 'package:leeds_library/presentation/bloc/welcome/welcome_block.dart';*/

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

  //sl.registerLazySingleton(() => GoogleAuthRepository(sl<Dio>()));
  sl.registerLazySingleton(() => GoogleAuthBloc(sl<AuthInterceptor>(),
      sl<SignInRepository>()));


  sl.registerLazySingleton(() => RegisterBloc(repository:sl<SignInRepository>()));




 /* CollectionDataSource dataSource = mockType == 'assets'
      ? MockFromAssetsCollectionDataSource()
      : MockFromGeneratorCollectionDataSource();

  sl.registerLazySingleton<CollectionDataSource>(() => dataSource);

  final cacheBox = await Hive.openBox<List<dynamic>>('collection_cache');
  sl.registerLazySingleton<Box<List<dynamic>>>(() => cacheBox);

  final collectionBox = await Hive.openBox<List<String>>('collection');
  sl.registerLazySingleton<Box<List<String>>>(() => collectionBox);

  sl.registerLazySingleton(
      () => LocalCollectionRepository(cacheBox: cacheBox, itemBox: itemBox, collectionBox: collectionBox));
  sl.registerLazySingleton<CollectionRepository>(
      () => CollectionRepositoryImpl(dataSource: sl()));

  // Register Connectivity
  sl.registerLazySingleton(() => Connectivity());

  //Collection list block
  sl.registerFactory(() {
    final bloc = CollectionsListBloc(
      repository: sl(),
      localRepository: sl(),
      connectivity: sl(),
    );
    bloc.add(FetchItemsEvent());
    return bloc;
  });

  //Details block
  sl.registerFactory(() {
    final bloc = BottleDetailsBloc(
      repository: sl(),
      localRepository: sl(),
      connectivity: sl(),
    );
    return bloc;
  });
*/


 //sl.registerFactory(() => SignInBloc(repository: sl<SignInRepository>()));

  sl.registerFactory(() => MainScreenBloc(repository: sl<SignInRepository>()));
}
