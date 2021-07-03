import 'dart:async';

import 'package:flutter/foundation.dart';

import '../protocols/validation.dart';

class LoginState {
  String emailError;
}

class StreamLoginPresenter {
  final Validation validation;

  // ?  broadcast mais de um listener no mesmo stream, sem isso a Stream tem apenas um listener
  final _controller = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError);

  StreamLoginPresenter({@required this.validation});

  void validateEmail({@required String email}) {
    _state.emailError = validation.validate(field: 'email', value: email);
    //? dispara evento passando o state
    _controller.add(_state);
  }
}