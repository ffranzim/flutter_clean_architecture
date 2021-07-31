import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class EmailValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  const EmailValidation({@required this.field});

  @override
  ValidationError validate({@required Map input}) {
    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final isValid = input[field]?.isNotEmpty != true || regex.hasMatch(input[field] as String);
    return isValid ? null : ValidationError.invalidField;
  }

  @override
  List<Object> get props => [field];
}
