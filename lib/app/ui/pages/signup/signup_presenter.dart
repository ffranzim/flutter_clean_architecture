import 'package:flutter/foundation.dart';

import '../../helpers/errors/errors.dart';

abstract class SignUpPresenter {

  Stream<UIError> get nameErrorStream;
  Stream<UIError> get emailErrorStream;
  Stream<UIError> get passwordErrorStream;
  Stream<UIError> get passwordConfirmationErrorStream;
  Stream<bool> get isFormValidStream;


  void validateName({@required String name});
  void validateEmail({@required String email});
  void validatePassword({@required String password});
  void validatePasswordConfirmation({@required String passwordConfirmation});
  Future<void> signUp();


}