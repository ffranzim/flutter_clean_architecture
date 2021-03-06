import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSurveyResultPresenter extends GetxController implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final String surveyId;

  final _isLoading = true.obs;
  final _surveyResult = Rx<SurveyResultViewModel>(null);

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

  @override
  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResult.stream;

  GetxSurveyResultPresenter({@required this.loadSurveyResult, @required this.surveyId});

  @override
  Future<void> loadData() async {
    try {
      _isLoading.value = true;

      final surveyResult = await loadSurveyResult.loadBySurvey(surveyId: surveyId);

      _surveyResult.value = SurveyResultViewModel(
        surveyId: surveyResult.surveyId,
        question: surveyResult.question,
        answers: surveyResult.answers
            .map((answer) => SurveyAnswerViewModel(
                image: answer.image,
                answer: answer.answer,
                isCurrentAnswer: answer.isCurrentAnswer,
                percent: '${answer.percent}%'))
            .toList(),
      );
    } on DomainError {
      // ?? Dá erro em produção e no teste não
      _surveyResult.subject.addError(UIError.unexpected.description);
      //_surveyResult.value = null;

    } finally {
      _isLoading.value = false;
    }
  }
}
