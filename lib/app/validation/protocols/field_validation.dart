import 'package:flutter/foundation.dart';

import '../../presentation/protocols/protocols.dart';

abstract class FieldValidation {
  String get field;

  ValidationError validate({@required Map input});

}