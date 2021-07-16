import 'package:clean_architecture/app/data/cache/cache.dart';
import 'package:clean_architecture/app/data/usecases/usecases.dart';
import 'package:clean_architecture/app/domain/entities/entities.dart';
import 'package:clean_architecture/app/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  FetchSecureCacheStorage fetchSecureCacheStorage;
  LocalLoadCurrentAccount sut;
  String token;

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
        fetchSecureCacheStorageSpy: fetchSecureCacheStorage);
    token = faker.guid.guid();
  });

  PostExpectation mockFetchSecureCall() =>
      when(fetchSecureCacheStorage.fetchSecure(key: anyNamed('key')));

  void mockFetchSecure() {
    mockFetchSecureCall().thenAnswer((_) async => token);
  }

  void mockFetchSecureError() {
    mockFetchSecureCall().thenThrow(Exception());
  }

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load(key: token);

    verify(fetchSecureCacheStorage.fetchSecure(key: token));
  });

  test('Should return an AccountEntity', () async {
    mockFetchSecure();

    final account = await sut.load(key: token);

    expect(account, AccountEntity(token: token));
  });

  test('Should throw UnexpectedError if FetchSecureCacheStorage throws',
      () async {
    mockFetchSecureError();

    final future = sut.load(key: 'token');

    expect(future, throwsA(DomainError.unexpected));
  });
}
