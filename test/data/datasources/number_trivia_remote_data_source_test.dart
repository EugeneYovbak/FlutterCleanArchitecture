import 'dart:convert';

import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_clean_architecture/data/datasource/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_architecture/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''should perform a request on a URL with number being the endpoint
      and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess();
        // act
        dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/$tNumber',
          headers: {
            'Content-Type': 'application/json',
          },
        ));
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
      '''should perform a request on a URL with random being the endpoint
      and with application/json header''',
          () async {
        // arrange
        setUpMockHttpClientSuccess();
        // act
        dataSource.getRandomNumberTrivia();
        // assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/random',
          headers: {
            'Content-Type': 'application/json',
          },
        ));
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
