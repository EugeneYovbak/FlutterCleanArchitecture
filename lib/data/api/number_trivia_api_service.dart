import 'package:chopper/chopper.dart';

part 'number_trivia_api_service.chopper.dart';

@ChopperApi()
abstract class NumberTriviaApiService extends ChopperService {
  static NumberTriviaApiService create([ChopperClient client]) => _$NumberTriviaApiService(client);

  @Get(headers: {'Content-Type': 'application/json'}, path: '/{number}')
  Future<Response> getConcreteNumberTrivia(@Path('number') int number);

  @Get(headers: {'Content-Type': 'application/json'}, path: '/random')
  Future<Response> getRandomNumberTrivia();
}
