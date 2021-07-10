import 'package:clean_architecture/app/domain/helpers/domain_error.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../domain/usecases/authentication.dart';
import '../../ui/pages/pages.dart';
import '../protocols/validation.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authetication authentication;

  String _email;
  String _password;

  GetxLoginPresenter(
      {@required this.validation, @required this.authentication});

  @override
  final RxString emailError = RxString('');
  @override
  final RxString passwordError = RxString('');
  @override
  final RxString mainError = RxString('');

  // ! Inicia com um observable false do getx
  @override
  final RxBool isFormValid = false.obs;
  @override
  final RxBool isLoading = false.obs;

  @override
  void validateEmail({@required String email}) {
    _email = email;
    emailError.value = validation.validate(field: 'email', value: email);
    validateForm();
  }

  @override
  void validatePassword({String password}) {
    _password = password;
    passwordError.value =
        validation.validate(field: 'password', value: password);
    validateForm();
  }

  void validateForm() {
    isFormValid.value = emailError.value == null &&
        passwordError.value == null &&
        _email != null &&
        _password != null;
  }

  @override
  Future<void> auth() async {
    isLoading.value = true;

    try {
      await authentication.auth(
          params: AuthenticationParams(email: _email, secret: _password));
    } on DomainError catch (error) {
      mainError.value = error.description;
    }

    isLoading.value = false;
  }
}
