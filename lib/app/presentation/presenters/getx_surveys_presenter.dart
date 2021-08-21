import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSurveysPresenter extends GetxController implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  final _isLoading = true.obs;
  final _surveys = RxList<SurveyViewModel>([]);

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

  @override
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  GetxSurveysPresenter({@required this.loadSurveys});

  @override
  Future<void> loadData() async {
    try {
      _isLoading.value = true;

      final surveysList = await loadSurveys.load();

      _surveys.value = surveysList
          .map(
            (survey) => SurveyViewModel(
              id: survey.id,
              question: survey.question,
              date: DateFormat('dd MMM yyyy').format(survey.dateTime),
              didAnswer: survey.didAnswer,
            ),
          ).toList();

    } on DomainError {

      _surveys.subject.addError(UIError.unexpected.description);
      // _surveys.addError(UIError.unexpected.description);
      // change([], status: RxStatus.error('message'));
      _surveys.value = [];

    } finally {
      _isLoading.value = false;
    }
  }



}
