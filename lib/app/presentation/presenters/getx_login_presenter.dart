import 'package:clean_architecture/app/domain/helpers/domain_error.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../domain/usecases/authentication.dart';
import '../../ui/pages/pages.dart';
import '../protocols/validation.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  String _email;
  String _password;

  RxString _emailError = RxString('');
  RxString _passwordError = RxString('');
  RxString _mainError = RxString('');
  RxBool _isFormValid = false.obs;
  RxBool _isLoading = false.obs;

  final Validation validation;
  final Authetication authentication;

  GetxLoginPresenter(
      {@required this.validation, @required this.authentication});

  // ! distinct só emite valor se o valor state for diferente
  @override
  Stream<String> get emailErrorStream => _emailError.stream;

  @override
  Stream<String> get passwordErrorStream => _passwordError.stream;

  @override
  Stream<String> get mainErrorStream => _mainError.stream;

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

  @override
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
      await authentication.auth(
          params: AuthenticationParams(email: _email, secret: _password));
    } on DomainError catch (error) {
      _mainError.value = error.description;
    }

    _isLoading.value = false;
  }

  @override
  void dispose() {
    //? Mantendo o metodo pelo uso na interface
  }
}
