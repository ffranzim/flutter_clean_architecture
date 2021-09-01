import 'package:clean_architecture/app/data/http/http.dart';
import 'package:clean_architecture/app/data/usecases/usecases.dart';
import 'package:clean_architecture/app/domain/entities/entities.dart';
import 'package:clean_architecture/app/domain/helpers/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  Uri url;
  HttpClient httpClient;
  RemoteLoadSurveyResult sut;
  Map surveyResult;

  Map mockValidData() =>
      {
        'surveyId': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'didAnswer': faker.randomGenerator.boolean(),
        'date': faker.date.dateTime().toIso8601String(),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'count': faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean()
          },
          {
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'count': faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean()
          },
        ]
      };

  PostExpectation mockRequest() =>
      when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
      ));

  void mockHttpData(Map data) {
    surveyResult = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    url = Uri.parse(faker.internet.httpUrl());
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveyResult(url: url, httpClient: httpClient);
    mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.loadBySurvey();

    verify(httpClient.request(url: url, method: 'get'));
  });

  test('Should return surveyResult on 200', () async {
    final result = await sut.loadBySurvey();

    expect(
        result,
        SurveyResultEntity(
            surveyId: surveyResult['surveyId'] as String,
            question: surveyResult['question'] as String,
            answers: [
              SurveyAnswerEntity(
                image: surveyResult['answers'][0]['image'] as String,
                answer: surveyResult['answers'][0]['answer'] as String,
              isCurrentAnswer: surveyResult['answers'][0]['isCurrentAccountAnswer'] as bool,
              percent: surveyResult['answers'][0]['percent'] as int,
              ),
              SurveyAnswerEntity(
                answer: surveyResult['answers'][1]['answer'] as String,
                isCurrentAnswer: surveyResult['answers'][1]['isCurrentAccountAnswer'] as bool,
                percent: surveyResult['answers'][1]['percent'] as int,
              ),
            ],)
    );
  });

  test('Should throw Unexpected if HttpClient returns 200 with invalid data', () async {
    mockHttpData({'invalid_key': 'invalid_value'});

    final future = sut.loadBySurvey();
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);
    final future = sut.loadBySurvey();
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);
    final future = sut.loadBySurvey();
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HttpClient returns 403', () async {
    mockHttpError(HttpError.forbidden);
    final future = sut.loadBySurvey();
    expect(future, throwsA(DomainError.accessDenied));
  });
}
