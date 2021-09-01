import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'entities.dart';

class SurveyResultEntity extends Equatable {
  final String surveyId;
  final String question;
    final List<SurveyAnswerEntity> answers;

  const SurveyResultEntity({
    @required this.surveyId,
    @required this.answers,
    @required this.question,
  });

  @override
  List<Object> get props => [surveyId, question, answers];
}
