import 'dart:async';

import 'survey_viewmodel.dart';

abstract class SurveysPresenter {
  Future<void> loadData();

  Stream<bool> get isLoadingStream;
  Stream<List<SurveyViewModel>> get surveysStream;
}