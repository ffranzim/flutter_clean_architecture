import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LocalLoadCurrentAccount {
  final FetchSecureCacheStorageSpy fetchSecureCacheStorageSpy;

  LocalLoadCurrentAccount({@required this.fetchSecureCacheStorageSpy});

  Future<void> load({@required String key}) async {
    await fetchSecureCacheStorageSpy.fetchSecure(key: key);
  }
}

abstract class FetchSecureCacheStorage {
  Future<void> fetchSecure({@required String key});
}

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {
}

void main() {
  test('Sould call FetchSecureCacheStorage with correct value', () async {
    final fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    final sut = LocalLoadCurrentAccount(fetchSecureCacheStorageSpy: fetchSecureCacheStorage);
    await sut.load(key: 'token');

    verify(fetchSecureCacheStorage.fetchSecure(key: 'token'));
  });
}
