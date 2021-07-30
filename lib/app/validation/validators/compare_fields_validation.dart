import 'package:flutter/foundation.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class CompareFieldsValidation implements FieldValidation {
  final String field;
  final String valueToCompare;

  CompareFieldsValidation({@required this.field, @required this.valueToCompare});

  @override
  ValidationError validate({String value}) {
    return ValidationError.invalidField;
  }
}