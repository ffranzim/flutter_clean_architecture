import 'dart:async';

import 'survey_viewmodel.dart';

abstract class SurveysPresenter {
  Future<void> loadData();
  void goToSurveyResult({String surveyId});

  Stream<bool> get isLoadingStream;
  Stream<List<SurveyViewModel>> get surveysStream;
  Stream<String> get navigateToStream;
}
