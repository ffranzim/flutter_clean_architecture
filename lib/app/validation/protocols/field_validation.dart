import 'package:flutter/foundation.dart';

abstract class FieldValidation {
  String get field;

  String validate({@required String value});
}