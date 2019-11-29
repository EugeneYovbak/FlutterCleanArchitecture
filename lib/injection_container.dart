import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_clean_architecture/core/network/network_info.dart';
import 'package:flutter_clean_architecture/core/util/input_converter.dart';
import 'package:flutter_clean_architecture/data/datasource/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_architecture/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_clean_architecture/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean_architecture/presentation/number_trivia/bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasource/number_trivia_local_data_source.dart';
import 'domain/repositories/number_trivia_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => DataConnectionChecker());

  // Core
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(serviceLocator()));

  // Data sources
  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: serviceLocator()));
  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: serviceLocator()));

  // Repositories
  serviceLocator.registerLazySingleton<NumberTriviaRepository>(() => NumberTriviaRepositoryImpl(
    remoteDataSource: serviceLocator(),
    localDataSource: serviceLocator(),
    networkInfo: serviceLocator(),
  ));

  // Use Cases
  serviceLocator.registerLazySingleton(() => GetConcreteNumberTrivia(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetRandomNumberTrivia(serviceLocator()));

  // Bloc
  serviceLocator.registerFactory(() => NumberTriviaBloc(
    getConcreteNumberTrivia: serviceLocator(),
    getRandomNumberTrivia: serviceLocator(),
    inputConverter: serviceLocator(),
  ));
}
