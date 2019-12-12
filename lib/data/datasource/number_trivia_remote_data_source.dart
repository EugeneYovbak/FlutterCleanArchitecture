import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_clean_architecture/data/api/number_trivia_api_service.dart';
import 'package:flutter_clean_architecture/data/models/number_trivia_model.dart';
import 'package:meta/meta.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final NumberTriviaApiService numberTriviaApiService;

  NumberTriviaRemoteDataSourceImpl({
    @required this.numberTriviaApiService,
  });

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final response = await numberTriviaApiService.getConcreteNumberTrivia(number);

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(response.body);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    final response = await numberTriviaApiService.getRandomNumberTrivia();

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(response.body);
    } else {
      throw ServerException();
    }
  }
}
