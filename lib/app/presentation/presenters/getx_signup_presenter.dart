import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../protocols/validation.dart';

class GetxSignUpPresenter extends GetxController implements SignUpPresenter {
  final _emailError = Rx<UIError>(null);
  final _nameError = Rx<UIError>(null);
  final _passwordError = Rx<UIError>(null);
  final _passwordConfirmationError = Rx<UIError>(null);
  final _mainError = Rx<UIError>(null);
  final RxString _navigateTo = RxString('');
  final RxBool _isFormValid = false.obs;
  final RxBool _isLoading = false.obs;

  String _email;
  String _name;
  String _password;
  String _passwordConfimation;

  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  GetxSignUpPresenter({
    @required this.validation,
    @required this.addAccount,
    @required this.saveCurrentAccount,
  });

  @override
  Stream<UIError> get nameErrorStream => _nameError.stream;

  @override
  Stream<UIError> get emailErrorStream => _emailError.stream;

  @override
  Stream<UIError> get passwordErrorStream => _passwordError.stream;

  @override
  Stream<UIError> get passwordConfirmationErrorStream =>
      _passwordConfirmationError.stream;

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
  void validateName({@required String name}) {
    _name = name;
    _nameError.value = _validateField(field: 'name', value: name);
    _validateForm();
  }

  @override
  void validatePassword({@required String password}) {
    _password = password;
    _passwordError.value = _validateField(field: 'password', value: password);
    _validateForm();
  }

  @override
  void validatePasswordConfirmation({@required String passwordConfirmation}) {
    _passwordConfimation = passwordConfirmation;
    _passwordConfirmationError.value = _validateField(
        field: 'passwordConfirmation', value: passwordConfirmation);
    _validateForm();
  }

  UIError _validateField({String field, String value}) {
    final error = validation.validate(field: field, value: value);
    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
        break;
      case ValidationError.requiredField:
        return UIError.requiredField;
        break;
      default:
        return null;
        break;
    }
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _nameError.value == null &&
        _passwordError.value == null &&
        _passwordConfirmationError.value == null &&
        _email != null &&
        _name != null &&
        _password != null &&
        _passwordConfimation != null;
  }

  @override
  Future<void> signUp() async {
    _isLoading.value = true;
    try {
      final account = await addAccount.add(
        params: AddAccountParams(
          email: _email,
          name: _name,
          password: _password,
          passwordConfirmation: _passwordConfimation,
        ),
      );
      await saveCurrentAccount.saveSecure(account: account);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      _isLoading.value = false;
      switch (error) {
        case DomainError.emailInUse:
          _mainError.value = UIError.emailInUse;
          break;
        default:
          _mainError.value = UIError.unexpected;
          break;
      }
      _isLoading.value = false;
    }
  }

  @override
  void goToLogin() {
    _navigateTo.value = '/login';
  }
}
