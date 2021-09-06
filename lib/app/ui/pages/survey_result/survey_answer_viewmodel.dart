import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class SurveyAnswerViewModel extends Equatable {
  final String image;
  final String answer;
  final bool isCurrentAnswer;
  final String percent;

  const SurveyAnswerViewModel({
    this.image,
    @required this.answer,
    @required this.isCurrentAnswer,
    @required this.percent,
  });

  @override
  List<Object> get props => [image, answer, isCurrentAnswer, percent];
}
