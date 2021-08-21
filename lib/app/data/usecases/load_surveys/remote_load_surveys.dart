import 'package:flutter/foundation.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadSurveys implements LoadSurveys {
  final Uri url;

  final HttpClient httpClient;

  RemoteLoadSurveys({@required this.url, @required this.httpClient});

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final httpResponse = await httpClient.request(url: url, method: 'get');

      // ignore: argument_type_not_assignable
      // return httpResponse
      //     .map((json) => RemoteSurveyModel.fromJson(json).toEntity())
      //     .toList();

      final surveysDynamic = httpResponse
          // ignore: argument_type_not_assignable
          .map((json) => RemoteSurveyModel.fromJson(json).toEntity())
          .toList();

      final surveysEntity = (surveysDynamic as List<dynamic>).cast<SurveyEntity>();

      return surveysEntity;
    } on HttpError catch (error) {
      error == HttpError.forbidden ? throw DomainError.accessDenied : throw DomainError.unexpected;
    }
  }
}
