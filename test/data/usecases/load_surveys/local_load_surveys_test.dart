import 'package:clean_architecture/app/data/models/models.dart';
import 'package:clean_architecture/app/domain/entities/entities.dart';
import 'package:clean_architecture/app/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LocalLoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({@required this.fetchCacheStorage});

  Future<List<SurveyEntity>> load() async {
    final data = await fetchCacheStorage.fetch('surveys');

    try {
      if (data?.isEmpty != false) {
        throw Exception();
      }

      final surveysDynamic =
          // ignore: argument_type_not_assignable
          data.map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity()).toList();
      final surveysEntity = (surveysDynamic as List<dynamic>).cast<SurveyEntity>();
      return surveysEntity;
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

abstract class FetchCacheStorage {
  Future<dynamic> fetch(String key);
}

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
          'dateTime': faker.date.dateTime(),
          'didAnswer': false,
        },
        {
          'id': faker.guid.guid(),
          'question': faker.lorem.random.string(10),
          'dateTime': faker.date.dateTime(),
          'didAnswer': false,
        }
      ];

  void mockFetch(List<Map> list) {
    data = list;
    when(fetchCacheStorage.fetch(any)).thenAnswer((_) async => data);
  }

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
          dateTime: data[0]['dateTime'] as DateTime,
          didAnswer: data[0]['didAnswer'] as bool),
      SurveyEntity(
          id: data[1]['id'] as String,
          question: data[1]['question'] as String,
          dateTime: data[1]['dateTime'] as DateTime,
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
}
