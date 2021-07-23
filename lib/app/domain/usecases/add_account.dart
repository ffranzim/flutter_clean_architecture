import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../entities/entities.dart';

abstract class AddAccount {
  Future<AccountEntity> add({@required AddAccountParams params});
}

class AddAccountParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  const AddAccountParams({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.passwordConfirmation,
  });

  @override
  List get props => [name, email, password, passwordConfirmation];
}
