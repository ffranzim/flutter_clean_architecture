import 'package:flutter/foundation.dart';

import '../../helpers/errors/errors.dart';

abstract class LoginPresenter {

  Stream<UIError> get emailErrorStream;
  Stream<UIError> get passwordErrorStream;
  Stream<UIError> get mainErrorStream;
  Stream<String> get navigateToStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  void validateEmail({@required String email});
  void validatePassword({@required String password});
  Future<void> auth();
  void dispose();

}