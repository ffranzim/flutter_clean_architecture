import 'package:clean_architecture/app/data/usecases/usecases.dart';
import 'package:clean_architecture/app/domain/entities/survey_entity.dart';
import 'package:clean_architecture/app/domain/usecases/usecases.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {
  final RemoteLoadSurveys remote;

  RemoteLoadSurveysWithLocalFallback({@required this.remote});

  @override
  Future<List<SurveyEntity>> load() async {
    await remote.load();
  }
}

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}
  RemoteLoadSurveys remote;
  RemoteLoadSurveysWithLocalFallback sut;

void main() {
  test('Should call remote load', () async {
    remote = RemoteLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote);

    sut.load();

    verify(remote.load()).called(1);

  });
}
