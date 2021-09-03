import 'dart:async';

abstract class SurveyResultPresenter {
  Future<void> loadData();
  Stream<bool> get isLoadingStream;
  Stream<dynamic> get surveyResultStream;
}