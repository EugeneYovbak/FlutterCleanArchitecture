import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_clean_architecture/data/api/number_trivia_api_service.dart';
import 'package:flutter_clean_architecture/data/datasource/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_architecture/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures/fixture_reader.dart';

class MockNumberTriviaApiService extends Mock implements NumberTriviaApiService {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockNumberTriviaApiService mockNumberTriviaApiService;

  setUp(() {
    mockNumberTriviaApiService = MockNumberTriviaApiService();
    dataSource = NumberTriviaRemoteDataSourceImpl(apiService: mockNumberTriviaApiService);
  });

  void setUpMockHttpClientSuccess() {
    final response = http.Response(fixture('trivia.json'), 200);
    when(mockNumberTriviaApiService.getConcreteNumberTrivia(any))
        .thenAnswer((_) async => Response(response, json.decode(response.body)));
    when(mockNumberTriviaApiService.getRandomNumberTrivia())
        .thenAnswer((_) async => Response(response, json.decode(response.body)));
  }

  void setUpMockHttpClientFailure() {
    final response = http.Response('Something went wrong', 404);
    when(mockNumberTriviaApiService.getConcreteNumberTrivia(any))
        .thenAnswer((_) async => Response(response, null));
    when(mockNumberTriviaApiService.getRandomNumberTrivia())
        .thenAnswer((_) async => Response(response, null));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      'should perform a request on a URL with number being the endpoint',
      () async {
        // arrange
        setUpMockHttpClientSuccess();
        // act
        dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockNumberTriviaApiService.getConcreteNumberTrivia(tNumber));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess();
        // act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should throw ServerException when the response code is 404 (failure)',
      () async {
        // arrange
        setUpMockHttpClientFailure();
        // act
        final call = dataSource.getConcreteNumberTrivia;
        // assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      'should perform a request on a URL with random being the endpoint',
      () async {
        // arrange
        setUpMockHttpClientSuccess();
        // act
        dataSource.getRandomNumberTrivia();
        // assert
        verify(mockNumberTriviaApiService.getRandomNumberTrivia());
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess();
        // act
        final result = await dataSource.getRandomNumberTrivia();
        // assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should throw ServerException when the response code is 404 (failure)',
      () async {
        // arrange
        setUpMockHttpClientFailure();
        // act
        final call = dataSource.getRandomNumberTrivia;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
