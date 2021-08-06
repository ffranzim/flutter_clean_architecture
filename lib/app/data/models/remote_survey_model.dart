import 'package:flutter/foundation.dart';

import '../../domain/entities/entities.dart';
import '../http/http_error.dart';

class RemoteSurveyModel {
  final String id;
  final String question;
  final String date;
  final bool didAnswer;

  RemoteSurveyModel({
    @required this.id,
    @required this.question,
    @required this.date,
    @required this.didAnswer,
  });

  factory RemoteSurveyModel.fromJson(Map json) {

    if (!json.keys.toSet().containsAll(['id', 'question', 'date', 'didAnswer'])) {
      throw HttpError.invalidData;
    }

    return RemoteSurveyModel(
      id: json['id'] as String,
      question: json['question'] as String,
      date: json['date'] as String,
      didAnswer: json['didAnswer'] as bool,
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
        id: id,
        question: question,
        dateTime: DateTime.parse(date),
        didAnswer: didAnswer,
      );
}
