import 'dart:async';

import 'survey_result_viewmodel.dart';

abstract class SurveyResultPresenter {
  Future<void> loadData();
  Stream<bool> get isLoadingStream;
  Stream<SurveyResultViewModel> get surveyResultStream;
}
