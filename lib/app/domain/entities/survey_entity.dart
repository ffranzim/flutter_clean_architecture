import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class SurveyEntity extends Equatable {
  final String id;
  final String question;
  final DateTime date;
  final bool didAnswer;

  const SurveyEntity({
    @required this.id,
    @required this.question,
    @required this.date,
    @required this.didAnswer,
  });

  @override
  List<Object> get props => [id, question, date, didAnswer] ;
}
