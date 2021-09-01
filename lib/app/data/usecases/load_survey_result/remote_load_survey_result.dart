import 'package:flutter/foundation.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadSurveyResult implements LoadSurveyResult {
  final Uri url;
  final HttpClient httpClient;

  RemoteLoadSurveyResult({@required this.url, @required this.httpClient});

  @override
   Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try {
      final json = await httpClient.request(url: url, method: 'get');

      // ignore: argument_type_not_assignable
      final surveysResult = RemoteSurveyResultModel.fromJson(json).toEntity();

      return surveysResult;
    } on HttpError catch (error) {
      error == HttpError.forbidden ? throw DomainError.accessDenied : throw DomainError.unexpected;
    }
  }
}
