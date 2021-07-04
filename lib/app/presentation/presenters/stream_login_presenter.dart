import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../ui/pages/pages.dart';
import '../protocols/validation.dart';

class LoginState {
  String email;
  String password;
  String emailError;
  String passwordError;

  bool get isFormValid => emailError == null && passwordError == null && email != null && password != null;
}

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;

  StreamLoginPresenter({@required this.validation});

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
  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();

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
  Future<void> auth() {
    // TODO: implement auth
    throw UnimplementedError();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  // TODO: implement isLoadingStream
  Stream<bool> get isLoadingStream => throw UnimplementedError();

  @override
  // TODO: implement mainErrorStream
  Stream<String> get mainErrorStream => throw UnimplementedError();
}
