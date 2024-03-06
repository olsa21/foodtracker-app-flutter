import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:foodtracker/2application/food/food_bloc.dart';
import 'package:foodtracker/3domain/repositories/FoodRepository.dart';
import 'package:foodtracker/3domain/usecases/FoodUseCase.dart';
import 'package:foodtracker/4infrastructure/datasources/FoodLocalDataSource.dart';
import 'package:foodtracker/4infrastructure/datasources/FoodRemoteDataSource.dart';
import 'package:foodtracker/4infrastructure/repositories/FoodRepositoryImpl.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '1presentation/routes/routes_import.dart';

final serviceLocator = GetIt.I;

Future<void> init() async{
  serviceLocator.registerSingleton<AppRouter>(AppRouter());

  //1. State Management
  serviceLocator.registerFactory(() => FoodBloc(usecase: serviceLocator()));

  //FoodUseCase
  serviceLocator.registerLazySingleton<FoodUseCase>(() => FoodUseCase(foodRepository: serviceLocator()));

  //FoodRepository
  serviceLocator.registerLazySingleton<FoodRepository>(() => FoodRepositoryImpl(foodRemoteDataSource: serviceLocator(), foodLocalDataSource: serviceLocator()));

  //DataSource
  serviceLocator.registerLazySingleton<FoodRemoteDataSource>(() => FoodRemoteDataSourceImpl(client: serviceLocator(), connectivity: serviceLocator()));
  final database = FoodLocalDataSourceImpl.instance;
  serviceLocator.registerLazySingleton<FoodLocalDataSource>(() => database);

  //extern
  //httpClient
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => Connectivity());
}