import 'package:clean_architecture/app/data/usecases/usecases.dart';
import 'package:clean_architecture/app/domain/entities/entities.dart';
import 'package:clean_architecture/app/domain/usecases/usecases.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {
  final RemoteLoadSurveys remote;
  final LocalLoadSurveys local;

  RemoteLoadSurveysWithLocalFallback(
      {@required this.remote, @required this.local});

  @override
  Future<List<SurveyEntity>> load() async {
    final surveys = await remote.load();
    await local.save(surveys);
    return surveys;
  }
}

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}

void main() {
  RemoteLoadSurveys remote;
  LocalLoadSurveys local;
  RemoteLoadSurveysWithLocalFallback sut;
  List<SurveyEntity> remoteSurveys;

  List<SurveyEntity> mockSurveys() => [
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.lorem.sentences(5).join(' '),
            date: faker.date.dateTime(),
            didAnswer: faker.randomGenerator.boolean()),
      ];

  void mockRemoteLoad() {
    remoteSurveys = mockSurveys();
    when(remote.load()).thenAnswer((_) async => remoteSurveys);
  }

  setUp(() {
    remote = RemoteLoadSurveysSpy();
    local = LocalLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote, local: local);
    mockRemoteLoad();
  });

  test('Should call remote load', () async {
    await sut.load();
    verify(remote.load()).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.load();
    verify(local.save(remoteSurveys)).called(1);
  });

  test('Should return remote data', () async {
    final surveys = await sut.load();

    expect(surveys, remoteSurveys);
  });
}
