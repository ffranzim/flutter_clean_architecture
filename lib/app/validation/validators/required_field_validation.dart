import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  const RequiredFieldValidation({@required this.field});

  @override
  ValidationError validate({@required Map input}) {
    final value = input[field] as String;
    return value?.isNotEmpty == true ? null : ValidationError.requiredField;
  }

  @override
  List get props => [field];
}
