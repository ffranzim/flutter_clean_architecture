import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/authentication.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../protocols/validation.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Logger _log = Logger();

  String _email;
  String _password;

  final _emailError = Rx<UIError>(null);
  final _passwordError = Rx<UIError>(null);
  final _mainError = Rx<UIError>(null);
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
  Stream<UIError> get emailErrorStream => _emailError.stream;

  @override
  Stream<UIError> get passwordErrorStream => _passwordError.stream;

  @override
  Stream<UIError> get mainErrorStream => _mainError.stream;

  @override
  Stream<String> get navigateToStream => _navigateTo.stream;

  @override
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

  @override
  void validateEmail({@required String email}) {
    _email = email;
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  @override
  void validatePassword({String password}) {
    _password = password;
    _passwordError.value = _validateField(field: 'password', value: password);
    _validateForm();
  }

  UIError _validateField({String field, String value}) {
    final error = validation.validate(field: field, value: value);
    switch (error) {
      case ValidationError.invalidField : return UIError.invalidField; break;
      case ValidationError.requiredField : return UIError.requiredField; break;
      default : return null; break;
    }
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
      await saveCurrentAccount.saveSecure(account: account);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {

      switch (error) {
        case DomainError.invalidCredentials: _mainError.value = UIError.invalidCredentials; break;
       default: _mainError.value = UIError.unexpected; break;
      }
      _isLoading.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    //? Mantendo o metodo pelo uso na interface
    _log.i('Call dispose');
  }

  @override
  void goToSignUp() {
    _navigateTo.value = '/signup';
  }
}
