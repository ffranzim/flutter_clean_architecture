import 'package:flutter/foundation.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite({@required this.validations});

  @override
  ValidationError validate({@required String field, @required Map input}) {
    ValidationError error;
    for(final validation in validations.where((element) => element.field == field)) {
      error = validation.validate(input: input);
      if(error != null) {
        return error;
      }
    }
    return error;
  }
}