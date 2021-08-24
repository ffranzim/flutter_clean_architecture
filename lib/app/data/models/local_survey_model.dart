import 'package:flutter/foundation.dart';

import '../../domain/entities/entities.dart';

class LocalSurveyModel {
  final String id;
  final String question;
  final DateTime date;
  final bool didAnswer;

  LocalSurveyModel({
    @required this.id,
    @required this.question,
    @required this.date,
    @required this.didAnswer,
  });

  factory LocalSurveyModel.fromJson(Map json) {

    if (!json.keys.toSet().containsAll(['id', 'question', 'date', 'didAnswer'])) {
      throw Exception();
    }

    return LocalSurveyModel(
      id: json['id'] as String,
      question: json['question'] as String,
      date: json['date'] as DateTime,
      didAnswer: json['didAnswer'] as bool,
    );
  }

  factory LocalSurveyModel.fromEntity(SurveyEntity entity) =>
    LocalSurveyModel(
      id: entity.id,
      question: entity.question,
      date: entity.date,
      didAnswer: entity.didAnswer,
    );


  SurveyEntity toEntity() => SurveyEntity(
        id: id,
        question: question,
        // dateTime: DateTime.parse(date),
        date: date,
        didAnswer: didAnswer,
      );

  Map toJson() => {
    'id': id,
    'question': question,
    'date': date,
    'didAnswer': didAnswer
  };
}

