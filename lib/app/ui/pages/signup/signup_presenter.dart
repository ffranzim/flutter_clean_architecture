import 'package:flutter/foundation.dart';

import '../../helpers/errors/errors.dart';

abstract class SignUpPresenter {
  Stream<UIError> get emailErrorStream;
  Stream<UIError> get nameErrorStream;
  Stream<UIError> get mainErrorStream;
  Stream<UIError> get passwordErrorStream;
  Stream<UIError> get passwordConfirmationErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;
  Stream<String> get navigateToStream;

  void validateName({@required String name});
  void validateEmail({@required String email});
  void validatePassword({@required String password});
  void validatePasswordConfirmation({@required String passwordConfirmation});
  Future<void> signUp();
  void goToLogin();
}
