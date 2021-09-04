import 'package:flutter/foundation.dart';

import 'survey_answer_viewmodel.dart';

class SurveyResultViewModel {
  final String surveyId;
  final String question;
  final List<SurveyAnswerViewModel> answers;

  SurveyResultViewModel({
    @required this.surveyId,
    @required this.question,
    @required this.answers,
  });
}
