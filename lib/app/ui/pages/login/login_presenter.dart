import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

abstract class LoginPresenter {

  RxString get emailError;
  RxString get passwordError;
  RxString get mainError;
  RxBool get isFormValid;
  RxBool get isLoading;

  void validateEmail({@required String email});
  void validatePassword({@required String password});
  Future<void> auth();
  Future<void> cleanMainError();

}