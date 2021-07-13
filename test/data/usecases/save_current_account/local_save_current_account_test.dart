import 'package:clean_architecture/app/data/cache/cache.dart';
import 'package:clean_architecture/app/data/usecases/usecases.dart';
import 'package:clean_architecture/app/domain/entities/entities.dart';
import 'package:clean_architecture/app/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
}

void main() {
  SaveSecureCacheStorageSpy cacheStorageSpy;
  LocalSaveCurrentAccount sut;
  AccountEntity account;

  setUp(() {
    cacheStorageSpy = SaveSecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorageSpy: cacheStorageSpy);
    account = AccountEntity(token: faker.guid.guid());
  });

  void mockError() {
    when(cacheStorageSpy.save(key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());
  }

  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account: account);

    verify(cacheStorageSpy.save(key: 'token', value: account.token));
  });

  test('Should throw UnexpetcedError if SaveSecureCacheStorage throws',
      () async {
    mockError();

    final future = sut.save(account: account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
