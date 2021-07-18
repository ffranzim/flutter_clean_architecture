import 'package:clean_architecture/app/domain/entities/entities.dart';
import 'package:clean_architecture/app/domain/usecases/usecases.dart';
import 'package:clean_architecture/app/presentation/presenters/presenters.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  LoadCurrentAccountSpy loadCurrentAccount;
  GetxSplashPresenter sut;

  PostExpectation mockLoadCurrentAccountCall() =>
      when(loadCurrentAccount.load(key: anyNamed('key')));

  void mockLoadCurrentAccount({@required AccountEntity account}) {
    mockLoadCurrentAccountCall().thenAnswer((_) async => account);
  }

  void mockLoadCurrentError() {
    mockLoadCurrentAccountCall().thenThrow(Exception());
  }

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    mockLoadCurrentAccount(account: AccountEntity(token: faker.guid.guid()));
  });

  test('Should call LoadCurrentAccount', () async {
    sut.checkAccount();

    verify(loadCurrentAccount.load(key: anyNamed('key'))).called(1);
  });

  test('Should go to surveys page on success', () async {
    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));

    sut.checkAccount();
  });

  test('Should go to login page on null result', () async {
    mockLoadCurrentAccount(account: null);

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    sut.checkAccount();
  });

  test('Should go to login page on error', () async {
    mockLoadCurrentError();

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    sut.checkAccount();
  });
}
