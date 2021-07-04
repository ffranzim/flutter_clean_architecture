import 'package:clean_architecture/app/validation/validators/required_field_validation.dart';
import 'package:flutter_test/flutter_test.dart';

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
