import 'package:flutter/foundation.dart';

import 'entities.dart';

class SurveyResultEntity {
  final String survey_id;
  final String question;
  final bool didAnswer;
  final List<SurveyAnswerEntity> answers;

  const SurveyResultEntity({
    @required this.survey_id,
    @required this.answers,
    @required this.question,
    @required this.didAnswer,
  });
}
