import 'package:clean_architecture/app/data/models/remote_survey_answer_model.dart';
import 'package:clean_architecture/app/domain/entities/entities.dart';
import 'package:flutter/foundation.dart';

import '../http/http_error.dart';
import 'remote_survey_answer_model.dart';

class RemoteSurveyResultModel {
  final String surveyId;
  final String question;
  final bool didAnswer;
  final List<SurveyAnswerEntity> answers;

  RemoteSurveyResultModel({
    @required this.surveyId,
    @required this.question,
    @required this.didAnswer,
    @required this.answers,
  });

  factory RemoteSurveyResultModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['surveyId', 'question', 'answers', 'didAnswer'])) {
      throw HttpError.invalidData;
    }

    return RemoteSurveyResultModel(
        surveyId: json['surveyId'] as String,
        question: json['question'] as String,
        didAnswer: json['didAnswer'] as bool,
        // ignore: argument_type_not_assignable
        answers: json['answers']
            .map<SurveyAnswerEntity>(
                (Map answersJson) => RemoteSurveyAnswerModel.fromJson(answersJson).toEntity())
            .toList());
  }

  SurveyResultEntity toEntity() => SurveyResultEntity(
        surveyId: surveyId,
        question: question,
        // ignore: argument_type_not_assignable
        answers: answers.map<SurveyAnswerEntity>((answer) => answer).toList(),
      );
}
