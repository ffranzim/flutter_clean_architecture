import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class SurveyViewModel extends Equatable {

  final String id;
  final String question;
  final String date;
  final bool didAnswer;

  const SurveyViewModel({
    @required this.id,
    @required this.question,
    @required this.date,
    @required this.didAnswer,
  });

  @override
  List<Object> get props => [id, question, date, didAnswer];
}
