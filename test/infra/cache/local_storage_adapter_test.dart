import 'package:clean_architecture/app/data/cache/cache.dart';
import 'package:clean_architecture/app/domain/helpers/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LocalStorageAdapter implements SaveSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStorageAdapter({@required this.secureStorage});

  @override
  Future<void> save({@required String key, @required String value}) async {
    await secureStorage.write(key: key, value: value);
  }
}

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  FlutterSecureStorageSpy secureStorage;
  LocalStorageAdapter sut;
  String key;
  String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  void mockSaveSecureError() =>
      when(secureStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenThrow(Exception());

  test('Should call save secure with correct values', () async {
    await sut.save(key: key, value: value);

    verify(secureStorage.write(key: key, value: value));
  });

  test('Should throw if save secure throws', () async {

    mockSaveSecureError();
    final future = sut.save(key: key, value: value);

    // ! TypeMatcher verifica se é do mesmo tipo - Tipo um instaceOf
    expect(future, throwsA(const TypeMatcher<Exception>()));
  });
}
