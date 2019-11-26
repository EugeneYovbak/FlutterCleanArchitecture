import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/core/platfrom/network_info.dart';
import 'package:flutter_clean_architecture/data/datasource/number_trivia_local_datasource.dart';
import 'package:flutter_clean_architecture/data/datasource/number_trivia_remote_datasource.dart';
import 'package:flutter_clean_architecture/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture/domain/repositories/number_trivia_repository.dart';
import 'package:meta/meta.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) {
    return null;
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    return null;
  }
}
