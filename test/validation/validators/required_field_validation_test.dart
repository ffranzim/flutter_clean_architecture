import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

abstract class FieldValidation {
  String get field;
  String validate({@required String value});
}

class RequiredFieldValidation implements FieldValidation {
  final String field;

  RequiredFieldValidation({@required this.field});

  @override
  String validate({String value}) {

    return value;
  }
}

void main() {
  test('Should return null if value is not empty', () {
    final sut = RequiredFieldValidation(field: 'any_field');

    final error = sut.validate(value: 'any_value');

    expect(error, null);
  });
}

