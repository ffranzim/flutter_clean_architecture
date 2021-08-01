import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class CompareFieldsValidation extends Equatable implements FieldValidation {
  @override
  final String field;
  final String fieldToCompare;

  const CompareFieldsValidation(
      {@required this.field, @required this.fieldToCompare});

  @override
  ValidationError validate({Map input}) {
    if (input == null ||
        input.isEmpty ||
        input[field] == null ||
        input[fieldToCompare] == null) {
      return null;
    }
    return input[field] != input[fieldToCompare] ? ValidationError.invalidField : null;
  }

  @override
  List get props => [field, fieldToCompare];
}
