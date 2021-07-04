import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

abstract class FieldValidation {
  String get field;

  String validate({@required String value});
}

class RequiredFieldValidation implements FieldValidation {
  @override
  final String field;

  RequiredFieldValidation({@required this.field});

   @override
  String validate({String value}) {
    return value?.isNotEmpty == true ? null : 'Campo Obrigatório.';
  }
}

void main() {

  RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation(field: 'any_field');
  });

  test('Should return null if value is not empty', () {
    final error = sut.validate(value: 'any_value');

    expect(error, null);
  });

  test('Should return error if value is empty', () {
    final error = sut.validate(value: '');

    expect(error, 'Campo Obrigatório.');
  });

  test('Should return error if value is null', () {
    final error = sut.validate(value: null);

    expect(error, 'Campo Obrigatório.');
  });
}
