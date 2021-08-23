import 'package:clean_architecture/app/domain/usecases/load_surveys.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../cache/cache.dart';
import '../../models/models.dart';


class LocalLoadSurveys implements LoadSurveys {
  final CacheStorage cacheStorage;

  LocalLoadSurveys({@required this.cacheStorage});

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final data = await cacheStorage.fetch('surveys');

      if (data?.isEmpty != false) {
        throw Exception();
      }

      final surveysDynamic =
          // ignore: argument_type_not_assignable
          data.map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity()).toList();
      final surveysEntity = (surveysDynamic as List<dynamic>).cast<SurveyEntity>();
      return surveysEntity;
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate() async {
    final data = await cacheStorage.fetch('surveys');
    try {
      final surveysDynamic =
      // ignore: argument_type_not_assignable
      data.map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity()).toList();
      final surveysEntity = (surveysDynamic as List<dynamic>).cast<SurveyEntity>();
      

    } catch (error) {
      await cacheStorage.delete('surveys');
    }

  }

}
