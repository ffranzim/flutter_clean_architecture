import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class SurveyAnswerEntity extends Equatable {
  final String image;
  final String answer;
  final bool isCurrentAnswer;
  final int percent;

  const SurveyAnswerEntity( {
    this.image,
    @required this.answer,
    @required this.isCurrentAnswer,
    @required this.percent,
  });

  @override
  List<Object> get props => [image, answer, isCurrentAnswer, percent];
}
