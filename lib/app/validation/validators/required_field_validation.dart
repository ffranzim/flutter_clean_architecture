import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  const RequiredFieldValidation({@required this.field});

  @override
  String validate({@required String value}) {
    return value?.isNotEmpty == true ? null : 'Campo Obrigatório.';
  }

  @override
  List get props => [field];
}
