import 'package:flutter/foundation.dart';

import '../protocols/protocols.dart';

class RequiredFieldValidation implements FieldValidation {
  @override
  final String field;

  RequiredFieldValidation({@required this.field});

  @override
  String validate({@required String value}) {
    return value?.isNotEmpty == true ? null : 'Campo Obrigatório.';
  }
}
