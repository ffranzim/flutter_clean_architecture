import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class AccountEntity extends Equatable {
  final String token;

  const AccountEntity({@required this.token});

  @override
  List<Object> get props => [token];


}
