import 'package:clean_architecture/app/data/cache/cache.dart';
import 'package:clean_architecture/app/data/usecases/usecases.dart';

import 'package:clean_architecture/app/domain/entities/entities.dart';
import 'package:clean_architecture/app/domain/helpers/helpers.dart';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

void main() {
  FetchCacheStorage fetchCacheStorage;
  LocalLoadSurveys sut;
  List<Map> data;

  //? DateTime.utc(2020, 7, 20)
  List<Map> mockValidData() => [
        {
          'id': faker.guid.guid(),
          'question': faker.lorem.random.string(10),
          'date': faker.date.dateTime(),
          'didAnswer': false,
        },
        {
          'id': faker.guid.guid(),
          'question': faker.lorem.random.string(10),
          'date': faker.date.dateTime(),
          'didAnswer': false,
        }
      ];

  void mockFetch(List<Map> list) {
    data = list;
    mockFetchCall(fetchCacheStorage).thenAnswer((_) async => data);
  }

  void mockFetchError() => mockFetchCall(fetchCacheStorage).thenThrow((_) => Exception());

  setUp(() {
    fetchCacheStorage = FetchCacheStorageSpy();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);
    mockFetch(mockValidData());
  });

  test('Should call FetchCacheStorage with correct key', () async {
    await sut.load();

    verify(fetchCacheStorage.fetch('surveys')).called(1);
  });

  test('Should return a list of surveys on success', () async {
    final surveys = await sut.load();

    expect(surveys, [
      SurveyEntity(
          id: data[0]['id'] as String,
          question: data[0]['question'] as String,
          date: data[0]['date'] as DateTime,
          didAnswer: data[0]['didAnswer'] as bool),
      SurveyEntity(
          id: data[1]['id'] as String,
          question: data[1]['question'] as String,
          date: data[1]['date'] as DateTime,
          didAnswer: data[1]['didAnswer'] as bool),
    ]);
  });

  test('Should throw UnexpectedError if cache is empty', () async {
    mockFetch([]);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if cache is null', () async {
    mockFetch(null);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if cache is invalid', () async {
    mockFetch([
      {
        'id': faker.guid.guid(),
        'question': faker.lorem.random.string(10),
        'dateTime': faker.lorem.sentence(),
        'didAnswer': false,
      }
    ]);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if cache is incomplete', () async {
    mockFetch([
      {
        'id': faker.guid.guid(),
        'dateTime': faker.date.dateTime(),
        'didAnswer': false,
      }
    ]);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if cache is incomplete', () async {
    mockFetchError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}

PostExpectation<Future<dynamic>> mockFetchCall(FetchCacheStorage fetchCacheStorage) =>
    when(fetchCacheStorage.fetch(any));
