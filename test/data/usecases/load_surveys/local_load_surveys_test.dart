import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LocalLoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({@required this.fetchCacheStorage});

  Future<void> load() async {
    await fetchCacheStorage.fetch('surveys');
  }
}

abstract class FetchCacheStorage {
  Future<void> fetch(String key);
}

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

void main() {
  test('Should call FetchCacheStorage with correct key', () async {
    final fetchCacheStorage = FetchCacheStorageSpy();
    final sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);

    await sut.load();

    verify(fetchCacheStorage.fetch('surveys')).called(1);
  });
}
