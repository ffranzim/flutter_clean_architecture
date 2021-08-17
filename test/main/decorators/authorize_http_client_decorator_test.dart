import 'package:clean_architecture/app/data/cache/cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class AuthorizeHttpClientDecorator {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  AuthorizeHttpClientDecorator({@required this.fetchSecureCacheStorage});

  Future<void> request() async {
    await fetchSecureCacheStorage.fetchSecure(key: 'token');
  }
}

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  test('Should call FetchSecureCacheStorage with correct key', () async {
    final fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    final sut = AuthorizeHttpClientDecorator(
        fetchSecureCacheStorage: fetchSecureCacheStorage);

    await sut.request();

    verify(fetchSecureCacheStorage.fetchSecure(key: 'token')).called(1);
  });
}
