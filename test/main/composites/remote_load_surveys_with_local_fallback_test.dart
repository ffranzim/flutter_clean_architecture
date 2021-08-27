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

void main() {
  RemoteLoadSurveys remote;
  RemoteLoadSurveysWithLocalFallback sut;

  setUp(() {
    remote = RemoteLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote);
  });

  test('Should call remote load', () async {
    sut.load();

    verify(remote.load()).called(1);
  });
}
