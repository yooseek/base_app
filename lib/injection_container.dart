import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import 'package:withapp_did/core/wedid_core.dart';
import 'package:withapp_did/data/wedid_data.dart';
import 'package:withapp_did/domain/wedid_domain.dart';
import 'package:withapp_did/presentation/wedid_presentation.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {
  //core
  serviceLocator.registerLazySingleton<Connectivity>(() => Connectivity());
  serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectionChecker: serviceLocator()));

  //local database
  serviceLocator.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage(aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  )));
  serviceLocator.registerLazySingleton<HiveInterface>(() => Hive);

  //dio
  serviceLocator.registerLazySingleton<Dio>(() => Dio()..interceptors.add(CustomInterceptor(storage: serviceLocator())));

  //remote service(retrofit)
  serviceLocator.registerLazySingleton<AuthAPI>(() => AuthAPI(serviceLocator(),baseUrl: '$ip/auth'));
  serviceLocator.registerLazySingleton<MemberAPI>(() => MemberAPI(serviceLocator(),baseUrl: '$ip/member'));

  //database
  serviceLocator.registerLazySingleton<TokenLocalDatabase>(() => TokenLocalDatabaseImpl(secureStorage: serviceLocator()));
  serviceLocator.registerLazySingleton<OnBoardLocalDatabase>(() => OnBoardLocalDatabaseImpl(hive: serviceLocator()));

  //repoimpl
  serviceLocator.registerLazySingleton<AuthRepository>(() =>
      AuthRepositoryImpl(
          networkInfo: serviceLocator(),
          tokenLocalDatabase: serviceLocator(),
          onBoardLocalDatabase: serviceLocator(),
          authAPI: serviceLocator(),
          memberAPI: serviceLocator(),
      ));

  //usecases - 생략

  //blocs
  serviceLocator.registerLazySingleton<GoRouterBloc>(() => GoRouterBloc(authRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<DialogBloc>(() => DialogBloc(authRepository: serviceLocator()));
  serviceLocator.registerFactory<SplashBloc>(() => SplashBloc(authRepository: serviceLocator()));
  serviceLocator.registerFactory<HomeBloc>(() => HomeBloc());
  serviceLocator.registerFactory<SignInBloc>(() => SignInBloc(authRepository: serviceLocator()));
  serviceLocator.registerFactory<SCPNBloc>(() => SCPNBloc(authRepository: serviceLocator()));
  serviceLocator.registerFactory<SignupBloc>(() => SignupBloc(authRepository: serviceLocator()));
  serviceLocator.registerFactory<OnboardBloc>(() => OnboardBloc(authRepository: serviceLocator()));

  // go_router
  serviceLocator.registerLazySingleton<GoRouter>(() => WEDIDGoRouterConfig().initialGoRouter());
}