import 'package:clean_architecture/app/data/cache/cache.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/mockito.dart';

class LocalStorageAdapter implements CacheStorage {
  final LocalStorage localStorage;

  LocalStorageAdapter({@required this.localStorage});
  
  @override
  Future<void> delete(String key) {
    throw UnimplementedError();
  }

  @override
  Future fetch(String key) {
    throw UnimplementedError();
  }

  @override
  Future<void> save({@required String key, @required dynamic value}) async {
    await localStorage.setItem(key, value);
  }
}

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  test('Should call localStorage with correct values', () async {
    final key = faker.randomGenerator.string(5);
    final value = faker.randomGenerator.string(50);
    final localStorage = LocalStorageSpy();
    final sut = LocalStorageAdapter(localStorage: localStorage);

    await sut.save(key: key, value: value);
    
    verify(localStorage.setItem(key, value)).called(1);
  });
}
