import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LocalLoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorageSpy;

  LocalLoadCurrentAccount({@required this.fetchSecureCacheStorageSpy});

  Future<void> load({@required String key}) async {
    await fetchSecureCacheStorageSpy.fetchSecure(key: key);
  }
}

abstract class FetchSecureCacheStorage {
  Future<void> fetchSecure({@required String key});
}

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  FetchSecureCacheStorage fetchSecureCacheStorage;
  LocalLoadCurrentAccount sut;

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
        fetchSecureCacheStorageSpy: fetchSecureCacheStorage);
  });

  test('Sould call FetchSecureCacheStorage with correct value', () async {
    await sut.load(key: 'token');

    verify(fetchSecureCacheStorage.fetchSecure(key: 'token'));
  });
}
