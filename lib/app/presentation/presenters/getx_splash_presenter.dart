import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

class GetxSplashPresenter implements SplashPresenter {
  final _navigateTo = RxString('');
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({@required this.loadCurrentAccount});

  @override
  Future<void> checkAccount({@required String key}) async {
    try {
      final account = await loadCurrentAccount.load(key: key);
      _navigateTo.value = account.isNull ? '/login' : '/surveys';
    } catch (error) {
      _navigateTo.value = '/login';
    }
  }

  @override
  Stream<String> get navigateToStream => _navigateTo.stream;
}
