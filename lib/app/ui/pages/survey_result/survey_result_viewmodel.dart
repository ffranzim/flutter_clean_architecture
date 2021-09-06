import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'survey_answer_viewmodel.dart';

class SurveyResultViewModel extends Equatable {
  final String surveyId;
  final String question;
  final List<SurveyAnswerViewModel> answers;

  const SurveyResultViewModel({
    @required this.surveyId,
    @required this.question,
    @required this.answers,
  });

  @override
  List<Object> get props => [surveyId, question, answers];
}
