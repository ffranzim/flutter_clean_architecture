import 'package:clean_architecture/app/presentation/protocols/validation.dart';
import 'package:clean_architecture/app/validation/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(field: 'any_field', valueToCompare: 'any_value');
  });

  test('Should return error if values are not equal', () {
    expect(sut.validate(value: 'wrong_value'), ValidationError.invalidField);
  });

  test('Should return null if values are equal', () {
    expect(sut.validate(value: 'any_value'), null);
  });

}
