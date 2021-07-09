import 'package:clean_architecture/app/data/cache/save_secure_cache_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';

class LocalStorageAdapater implements SaveSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStorageAdapater({@required this.secureStorage});

  @override
  Future<void> saveSecure(
      {@required String key, @required String value}) async {
    await secureStorage.write(key: key, value: value);
  }
}

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  test('Should call save secure with correct values', () async {
    final secureStorage = FlutterSecureStorageSpy();
    final sut = LocalStorageAdapater(secureStorage: secureStorage);
    final key = faker.lorem.word();
    final value = faker.guid.guid();

    await sut.saveSecure(key: key, value: value);

    verify(secureStorage.write(key: key, value: value));
  });
}
