import 'package:clean_architecture/app/data/http/http.dart';
import 'package:clean_architecture/app/data/models/models.dart';
import 'package:clean_architecture/app/domain/entities/entities.dart';
import 'package:clean_architecture/app/domain/helpers/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class RemoteLoadSurveys {
  final Uri url;
  final HttpClient<List<Map>> httpClient;

  RemoteLoadSurveys({@required this.url, @required this.httpClient});

  Future<List<SurveyEntity>> load() async {
    try {
      final httpResponse = await httpClient.request(url: url, method: 'get');
      return httpResponse
          .map((json) => RemoteSurveyModel.fromJson(json).toEntity())
          .toList();
    } on HttpError {
      throw DomainError.unexpected;
    }
  }
}

class HttpClientSpy extends Mock implements HttpClient<List<Map>> {}

void main() {
  Uri url;
  HttpClient<List<Map>> httpClient;
  RemoteLoadSurveys sut;
  List<Map> list;

  List<Map> mockValidData() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String(),
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String(),
        }
      ];

  PostExpectation mockRequest() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
      ));

  void mockHttpData(List<Map> data) {
    list = data;
    mockRequest().thenAnswer((_) async => data);
  }

  setUp(() {
    url = Uri.parse(faker.internet.httpUrl());
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
    mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });

  test('Should return surveys on 200', () async {
    final surveys = await sut.load();

    expect(surveys, [
      SurveyEntity(
          id: list[0]['id'] as String,
          question: list[0]['question'] as String,
          dateTime: DateTime.parse(list[0]['date'] as String),
          didAnswer: list[0]['didAnswer'] as bool),
      SurveyEntity(
          id: list[1]['id'] as String,
          question: list[1]['question'] as String,
          dateTime: DateTime.parse(list[1]['date'] as String),
          didAnswer: list[1]['didAnswer'] as bool),
    ]);
  });

  test('Should throw Unexpected if HttpClient returns 200 with invalid data',
      () async {
    mockHttpData([
      {'invalid_key': 'invalid_value'}
    ]);
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });
}
