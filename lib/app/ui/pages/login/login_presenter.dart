import 'package:flutter/foundation.dart';

abstract class LoginPresenter {

  Stream<String> get emailErrorStream;
  Stream<String> get passwordErrorStream;
  Stream<String> get mainErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  void validateEmail({@required String email});
  void validatePassword({@required String password});
  Future<void> auth();
  void dispose();

}