import 'package:clean_architecture/app/domain/usecases/usecases.dart';
import 'package:clean_architecture/app/ui/pages/pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class GetxSplashPresenter implements SplashPresenter {
  final _navigateTo = RxString('');
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({@required this.loadCurrentAccount});

  @override
  Future<void> checkAccount({@required String key}) async {
    await loadCurrentAccount.load(key: key);
  }

  @override
  Stream<String> get navigateToStream => _navigateTo.stream;
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {
}

void main() {
  test('Should call LoadCurrentAccount', () async {
    final loadCurrentAccount = LoadCurrentAccountSpy();
    final sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);

    sut.checkAccount();

    verify(loadCurrentAccount.load(key: anyNamed('key'))).called(1);
  });
}
