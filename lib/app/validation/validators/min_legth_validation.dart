import 'package:flutter/foundation.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class MinLengthValidation implements FieldValidation {
  final String field;
  final int minSize;

  MinLengthValidation({@required this.field, @required this.minSize});

  @override
  ValidationError validate({String value}) {
    if (value == null || value.length < minSize) {
      return ValidationError.invalidField;
    }
    return null;
  }
}