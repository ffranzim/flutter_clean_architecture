import 'dart:async';

import 'package:clean_architecture/app/domain/helpers/domain_error.dart';
import 'package:flutter/foundation.dart';

import '../../domain/usecases/authentication.dart';
import '../../ui/pages/pages.dart';
import '../protocols/validation.dart';

class LoginState {
  String email;
  String password;
  String emailError;
  String passwordError;
  String mainError;

  bool isLoading = false;

  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
      email != null &&
      password != null;
}

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;
  final Authetication authentication;

  StreamLoginPresenter(
      {@required this.validation, @required this.authentication});

  // ?  broadcast mais de um listener no mesmo stream, sem isso a Stream tem apenas um listener
  final _controller = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  // ! distinct só emite valor se o valor state for diferente
  @override
  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError).distinct();

  @override
  Stream<String> get passwordErrorStream =>
      _controller.stream.map((state) => state.passwordError).distinct();

  @override
  Stream<String> get mainErrorStream =>  _controller.stream.map((state) => state.mainError).distinct();


  @override
  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();

  @override
  Stream<bool> get isLoadingStream => _controller.stream.map((event) => _state.isLoading).distinct();

  //? dispara evento passando o state
  void _update() => _controller.add(_state);

  @override
  void validateEmail({@required String email}) {
    _state.email = email;
    _state.emailError = validation.validate(field: 'email', value: email);
    _update();
  }

  @override
  void validatePassword({String password}) {
    _state.password = password;
    _state.passwordError =
        validation.validate(field: 'password', value: password);
    _update();
  }

  @override
  Future<void> auth() async {
    _state.isLoading = true;
    _update();

    try {
      await authentication.auth(
          params:
          AuthenticationParams(email: _state.email, secret: _state.password));
    } on DomainError catch (error) {
      _state.mainError = error.description;
    }

    _state.isLoading = false;
    _update();
  }


  @override
  void dispose() {
    // TODO: implement dispose
  }




}
