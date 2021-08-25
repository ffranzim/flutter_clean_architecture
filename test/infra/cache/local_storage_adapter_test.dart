import 'package:clean_architecture/app/data/cache/cache.dart';
import 'package:clean_architecture/app/domain/helpers/helpers.dart';
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
    await localStorage.deleteItem(key);
    await localStorage.setItem(key, value);
  }
}

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  LocalStorageAdapter sut;
  LocalStorage localStorage;
  String key;
  dynamic value;

  void mockDeleteItemError() => when(localStorage.deleteItem(any)).thenThrow(Exception());
  void mockSetItemError() => when(localStorage.setItem(any, any)).thenThrow(Exception());

  setUp(() {
    localStorage = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorage);
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
  });

  test('Should call localStorage with correct values', () async {
    await sut.save(key: key, value: value);

    verify(localStorage.deleteItem(key)).called(1);
    verify(localStorage.setItem(key, value)).called(1);
  });

  test('Should throw if deleteItem throws', () async {
    mockDeleteItemError();
    final future = sut.save(key: key, value: value);

    expect(future, throwsA(const TypeMatcher<Exception>()));
  });

  test('Should throw if setItem throws', () async {
    mockSetItemError();
    final future = sut.save(key: key, value: value);

    expect(future, throwsA(const TypeMatcher<Exception>()));
  });
}
