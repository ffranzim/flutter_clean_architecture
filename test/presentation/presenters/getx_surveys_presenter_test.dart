import 'package:clean_architecture/app/domain/usecases/usecases.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class GetxSurveysPresenter {
  final LoadSurveys loadSurveys;

  GetxSurveysPresenter({@required this.loadSurveys});
  Future<void> loadData() async {
    await loadSurveys.load();
  }
}

class LoadSurveysSpy extends Mock implements LoadSurveys {

}
void main() {
  test('Should call LoadSurveys on loadData', () async {
    final loadSurveys = LoadSurveysSpy();
    final sut = GetxSurveysPresenter(loadSurveys: loadSurveys);

    await sut.loadData();

    verify(loadSurveys.load()).called(1);

  });
}
