import 'dart:async';

import 'package:clean_architecture/app/ui/helpers/helpers.dart';
import 'package:get/get.dart';

import 'survey_viewmodel.dart';

abstract class SurveysPresenter {
  Future<void> loadData();

  Stream<bool> get isLoadingStream;
  Stream<List<SurveyViewModel>> get surveysStream;

  // RxList<SurveyViewModel> surveys;

}