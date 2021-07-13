import 'package:clean_architecture/app/domain/entities/entities.dart';
import 'package:clean_architecture/app/domain/helpers/helpers.dart';
import 'package:clean_architecture/app/domain/usecases/usecases.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorageSpy saveSecureCacheStorageSpy;

  LocalSaveCurrentAccount({@required this.saveSecureCacheStorageSpy});

  @override
  Future<void> save({@required AccountEntity account}) async {
    try {
      await saveSecureCacheStorageSpy.save(key: 'token', value: account.token);
    } catch(error) {
      throw DomainError.unexpected;
    }
  }
}

abstract class SaveSecureCacheStorage {
  Future<void> save({@required String key, @required String value});
}

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {}

void main() {
  test('Should call SaveSecureCacheStorage with correct values', () async {
    final cacheStorageSpy = SaveSecureCacheStorageSpy();
    final sut =
        LocalSaveCurrentAccount(saveSecureCacheStorageSpy: cacheStorageSpy);
    final account = AccountEntity(token: faker.guid.guid());

    await sut.save(account: account);

    verify(cacheStorageSpy.save(key: 'token', value: account.token));
  });

  test('Should throw UnexpetcedError if SaveSecureCacheStorage throws', () async {
    final cacheStorageSpy = SaveSecureCacheStorageSpy();
    final sut =
        LocalSaveCurrentAccount(saveSecureCacheStorageSpy: cacheStorageSpy);
    final account = AccountEntity(token: faker.guid.guid());
    when(cacheStorageSpy.save(key: anyNamed('key'), value: anyNamed('value'))).thenThrow(Exception());

    final future = sut.save(account: account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
