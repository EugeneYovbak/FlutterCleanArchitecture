import 'package:chopper/chopper.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_clean_architecture/core/util/input_converter.dart';
import 'package:flutter_clean_architecture/core/util/network_info.dart';
import 'package:flutter_clean_architecture/data/api/number_trivia_api_service.dart';
import 'package:flutter_clean_architecture/data/datasource/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_architecture/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_clean_architecture/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean_architecture/presentation/number_trivia/bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasource/number_trivia_local_data_source.dart';
import 'domain/repositories/number_trivia_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // Bloc
  serviceLocator.registerFactory(() => NumberTriviaBloc(
        getConcreteNumberTrivia: serviceLocator(),
        getRandomNumberTrivia: serviceLocator(),
        inputConverter: serviceLocator(),
      ));

  // Use Cases
  serviceLocator.registerLazySingleton(() => GetConcreteNumberTrivia(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetRandomNumberTrivia(serviceLocator()));

  // Repositories
  serviceLocator.registerLazySingleton<NumberTriviaRepository>(() => NumberTriviaRepositoryImpl(
        remoteDataSource: serviceLocator(),
        localDataSource: serviceLocator(),
        networkInfo: serviceLocator(),
      ));

  // Data sources
  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(apiService: serviceLocator()));
  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: serviceLocator()));

  // Core
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(serviceLocator()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);

  serviceLocator.registerLazySingleton(() => DataConnectionChecker());

  final chopperClient = ChopperClient(
    baseUrl: 'http://numbersapi.com',
    services: [
      NumberTriviaApiService.create(),
    ],
    converter: JsonConverter(),
  );
  serviceLocator.registerLazySingleton(() => chopperClient.getService<NumberTriviaApiService>());
}
