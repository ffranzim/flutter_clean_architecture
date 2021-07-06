import 'package:flutter/foundation.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite({@required this.validations});

  @override
  String validate({@required String field, @required String value}) {
    String error;
    for(final validation in validations.where((element) => element.field == field)) {
      error = validation.validate(value: value);
      if(error?.isNotEmpty == true) {
        return error;
      }
    }
    return error;
  }
}