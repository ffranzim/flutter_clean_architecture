import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../entities/entities.dart';

abstract class Authetication {
  Future<AccountEntity> auth({@required AuthenticationParams params});
}

class AuthenticationParams extends Equatable {
  final String email;
  final String secret;

  const AuthenticationParams({@required this.email, @required this.secret});

  @override
  List get props => [email, secret];
}
