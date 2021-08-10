import 'package:flutter/foundation.dart';

class SurveyViewModel {

  final String id;
  final String question;
  final String dateTime;
  final bool didAnswer;

  const SurveyViewModel({
    @required this.id,
    @required this.question,
    @required this.dateTime,
    @required this.didAnswer,
  });
}
