import 'package:flutter/foundation.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/load_surveys.dart';
import '../../cache/cache.dart';
import '../../models/models.dart';

class LocalLoadSurveys implements LoadSurveys {
  final CacheStorage cacheStorage;

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final data = await cacheStorage.fetch('surveys');

      if (data?.isEmpty != false) {
        throw Exception();
      }

      return _castDynamicToListSurveys(data);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  LocalLoadSurveys({@required this.cacheStorage});

  Future<void> validate() async {
    try {
      final data = await cacheStorage.fetch('surveys');
      return _castDynamicToListSurveys(data);
    } catch (error) {
      await cacheStorage.delete('surveys');
    }
  }

  Future<void> save(List<SurveyEntity> surveys) async {
    try {
      await cacheStorage.save(key: 'surveys', value: _mapToJson(surveys));
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  List _mapToJson(List<SurveyEntity> list) {
   return list.map((entity) => LocalSurveyModel.fromEntity(entity).toJson()).toList();
  }

  List<SurveyEntity> _castDynamicToListSurveys(dynamic data) {
    final surveysDynamic =
        // ignore: argument_type_not_assignable
        data.map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity()).toList();
    final surveysEntity = (surveysDynamic as List<dynamic>).cast<SurveyEntity>();
    return surveysEntity;
  }
}
