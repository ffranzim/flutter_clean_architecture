import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  final String field;
  final int minSize;

  const MinLengthValidation({@required this.field, @required this.minSize});

  @override
  ValidationError validate({Map input}) {
    String value = input[field] as String;
    if (value == null || value.length < minSize) {
      return ValidationError.invalidField;
    }
    return null;
  }

  @override
  List get props => [field, minSize];
}