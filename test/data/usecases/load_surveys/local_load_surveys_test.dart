import 'package:clean_architecture/app/data/cache/cache.dart';
import 'package:clean_architecture/app/data/usecases/usecases.dart';

import 'package:clean_architecture/app/domain/entities/entities.dart';
import 'package:clean_architecture/app/domain/helpers/helpers.dart';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  group('load', () {
    CacheStorage cacheStorage;
    LocalLoadSurveys sut;
    List<Map> data;

    //? DateTime.utc(2020, 7, 20)
    List<Map> mockValidData() => [
          {
            'id': faker.guid.guid(),
            'question': faker.lorem.random.string(10),
            'date': faker.date.dateTime().toIso8601String(),
            'didAnswer': false,
          },
          {
            'id': faker.guid.guid(),
            'question': faker.lorem.random.string(10),
            'date': faker.date.dateTime().toIso8601String(),
            'didAnswer': false,
          }
        ];

    PostExpectation<Future<dynamic>> mockFetchCall(CacheStorage cache) => when(cache.fetch(any));

    void mockFetch(List<Map> list) {
      data = list;
      mockFetchCall(cacheStorage).thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall(cacheStorage).thenThrow((_) => Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockFetch(mockValidData());
    });

    test('Should call FetchCacheStorage with correct key', () async {
      await sut.load();

      verify(cacheStorage.fetch('surveys')).called(1);
    });

    test('Should return a list of surveys on success', () async {
      final surveys = await sut.load();

      expect(surveys, [
        SurveyEntity(
            id: data[0]['id'] as String,
            question: data[0]['question'] as String,
            date: DateTime.parse(data[0]['date'] as String),
            didAnswer: data[0]['didAnswer'] as bool),
        SurveyEntity(
            id: data[1]['id'] as String,
            question: data[1]['question'] as String,
            date: DateTime.parse(data[1]['date'] as String),
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
  });

  group('validate', () {
    CacheStorage cacheStorage;
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

    PostExpectation<Future<dynamic>> mockFetchCall(CacheStorage cache) => when(cache.fetch(any));

    void mockFetch(List<Map> list) {
      data = list;
      mockFetchCall(cacheStorage).thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall(cacheStorage).thenThrow((_) => Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockFetch(mockValidData());
    });

    test('Should call cacheStorage with correct key', () async {
      await sut.validate();

      verify(cacheStorage.fetch('surveys')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      mockFetch([
        {
          'id': faker.guid.guid(),
          'question': faker.lorem.random.string(10),
          'date': 'invalid date',
          'didAnswer': false,
        }
      ]);

      await sut.validate();
      verify(cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      mockFetchError();

      await sut.validate();
      verify(cacheStorage.delete('surveys')).called(1);
    });
  });
  group('save', () {
    CacheStorage cacheStorage;
    LocalLoadSurveys sut;
    List<SurveyEntity> _surveys;

    PostExpectation<Future<dynamic>> mockFSaveCall(CacheStorage cache) =>
        when(cache.save(key: anyNamed('key'), value: anyNamed('value')));

    void mockSaveError() => mockFSaveCall(cacheStorage).thenThrow((_) => Exception());

    List<SurveyEntity> mockSurveys() => [
          SurveyEntity(
              id: faker.guid.guid(),
              question: faker.lorem.sentence(),
              date: DateTime.utc(2020, 6, 3),
              didAnswer: false),
          SurveyEntity(
              id: faker.guid.guid(),
              question: faker.lorem.sentence(),
              date: DateTime.utc(2020, 1, 11),
              didAnswer: true),
        ];

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      _surveys = mockSurveys();
    });

    test('Should call cacheStorage with correct values ', () async {
      final list = [
        {
          'id': _surveys[0].id,
          'question': _surveys[0].question,
          'date': _surveys[0].date.toIso8601String(),
          'didAnswer': _surveys[0].didAnswer,
        },
        {
          'id': _surveys[1].id,
          'question': _surveys[1].question,
          'date': _surveys[1].date.toIso8601String(),
          'didAnswer': _surveys[1].didAnswer,
        }
      ];

      await sut.save(_surveys);

      verify(cacheStorage.save(key: 'surveys', value: list)).called(1);
    });

    test('Should throw UnexpectedError if save throws ', () async {
      mockSaveError();

      final future =  sut.save(_surveys);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
