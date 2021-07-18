import 'package:clean_architecture/app/domain/usecases/usecases.dart';
import 'package:clean_architecture/app/ui/pages/pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class GetxSplashPresenter implements SplashPresenter {
  RxString _navigateTo = RxString('');
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({@required this.loadCurrentAccount});

  @override
  Future<void> checkAccount({@required String key}) async {
    await loadCurrentAccount.load(key: key);
    _navigateTo.value = '/surveys';
  }

  @override
  Stream<String> get navigateToStream => _navigateTo.stream;
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  LoadCurrentAccountSpy loadCurrentAccount;
  GetxSplashPresenter sut;

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
  });

  test('Should call LoadCurrentAccount', () async {
    sut.checkAccount();

    verify(loadCurrentAccount.load(key: anyNamed('key'))).called(1);
  });

  test('Should go to surveys page on success', () async {

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/surveys')));

    sut.checkAccount();

    verify(loadCurrentAccount.load(key: anyNamed('key'))).called(1);
  });
}
