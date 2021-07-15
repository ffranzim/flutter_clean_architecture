import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/authentication.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../protocols/validation.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Logger _log = Logger();

  String _email;
  String _password;

  final RxString _emailError = RxString('');
  final RxString _passwordError = RxString('');
  final RxString _mainError = RxString('');
  final RxString _navigateTo = RxString('');
  final RxBool _isFormValid = false.obs;
  final RxBool _isLoading = false.obs;

  final Validation validation;
  final Authetication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  GetxLoginPresenter({
    @required this.validation,
    @required this.authentication,
    @required this.saveCurrentAccount,
  });

  // ! distinct só emite valor se o valor state for diferente
  @override
  Stream<String> get emailErrorStream => _emailError.stream;

  @override
  Stream<String> get passwordErrorStream => _passwordError.stream;

  @override
  Stream<String> get mainErrorStream => _mainError.stream;

  @override
  Stream<String> get navigateToStream => _navigateTo.stream;

  @override
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

  @override
  void validateEmail({@required String email}) {
    _email = email;
    _emailError.value = validation.validate(field: 'email', value: email);
    _validateForm();
  }

  @override
  void validatePassword({String password}) {
    _password = password;
    _passwordError.value =
        validation.validate(field: 'password', value: password);
    _validateForm();
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
  }

  @override
  Future<void> auth() async {
    _isLoading.value = true;

    try {
      final account = await authentication.auth(
          params: AuthenticationParams(email: _email, secret: _password));
      await saveCurrentAccount.save(account: account);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      _mainError.value = error.description;
      _isLoading.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    //? Mantendo o metodo pelo uso na interface
    _log.i('Call dispose');
  }
}
