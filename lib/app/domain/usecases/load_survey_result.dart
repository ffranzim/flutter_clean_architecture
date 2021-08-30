import '../entities/entities.dart';


abstract class LoadSurveyResult {
  Future<SurveyAnswerEntity> loadBySurvey({String surveyId});
}
