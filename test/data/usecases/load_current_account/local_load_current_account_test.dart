import 'package:clean_architecture/app/domain/entities/account_entity.dart';
import 'package:clean_architecture/app/domain/usecases/load_current_account.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorageSpy;

  LocalLoadCurrentAccount({@required this.fetchSecureCacheStorageSpy});

  @override
  Future<AccountEntity> load({@required String key}) async {
    final token = await fetchSecureCacheStorageSpy.fetchSecure(key: key);
    return AccountEntity(token: token);
  }
}

abstract class FetchSecureCacheStorage {
  Future<String> fetchSecure({@required String key});
}

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

  void mockFetchSecure() => when(fetchSecureCacheStorage.fetchSecure(key: anyNamed('key'))).thenAnswer((_) async => token);

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load(key: 'token');

    verify(fetchSecureCacheStorage.fetchSecure(key: 'token'));
  });

  test('Should return an AccountEntity', () async {
    mockFetchSecure();

    final account = await sut.load(key: 'token');

    expect(account, AccountEntity(token: token));
  });
}
