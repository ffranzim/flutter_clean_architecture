import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../ui/helpers/helpers.dart';
import '../protocols/validation.dart';

class GetxSignUpPresenter extends GetxController {//implements SignUpPresenter {

  final _emailError = Rx<UIError>(null);
  final _nameError = Rx<UIError>(null);
  final _passwordError = Rx<UIError>(null);
  final RxBool _isFormValid = false.obs;

  final Validation validation;

  GetxSignUpPresenter({
    @required this.validation,
  });

  // @override
  Stream<UIError> get nameErrorStream => _nameError.stream;

  // @override
  Stream<UIError> get emailErrorStream => _emailError.stream;

  Stream<UIError> get passwordErrorStream => _passwordError.stream;

  // @override
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  // @override
  void validateEmail({@required String email}) {
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  // @override
  void validateName({@required String name}) {
    _nameError .value = _validateField(field: 'name', value: name);
    _validateForm();
  }

  void validatePassword({@required String password}) {
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
    _isFormValid.value = false;
  }
 }
