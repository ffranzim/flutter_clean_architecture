import 'package:flutter/foundation.dart';

import '../../domain/entities/entities.dart';
import '../http/http_error.dart';

class RemoteSurveyAnswerModel {
  final String image;
  final String answer;
  final bool isCurrentAccountAnswer;
  final int percent;

  RemoteSurveyAnswerModel({
    this.image,
    @required this.answer,
    @required this.isCurrentAccountAnswer,
    @required this.percent,
  });

  factory RemoteSurveyAnswerModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['answer', 'isCurrentAccountAnswer', 'percent'])) {
      throw HttpError.invalidData;
    }

    return RemoteSurveyAnswerModel(
      image: json['image'] as String,
      answer: json['answer'] as String,
      isCurrentAccountAnswer: json['isCurrentAccountAnswer'] as bool,
      percent: json['percent'] as int,
    );
  }

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
        image: image,
        answer: answer,
        isCurrentAnswer: isCurrentAccountAnswer,
        percent: percent,
      );
}
