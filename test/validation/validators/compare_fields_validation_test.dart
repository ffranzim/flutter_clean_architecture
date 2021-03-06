import 'package:clean_architecture/app/presentation/protocols/validation.dart';
import 'package:clean_architecture/app/validation/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = const CompareFieldsValidation(field: 'any_field', fieldToCompare: 'other_field');
  });

  test('Should return null on invalid cases', () {
    final formDataJustAnyField = {'any_field': 'any_value'};
    final formDataJustOtherField = {'other_field': 'other_value'};
    final formDataEmpty = {};

    expect(sut.validate(), null);
    expect(sut.validate(input: formDataEmpty), null);
    expect(sut.validate(input: formDataJustOtherField), null);
    expect(sut.validate(input: formDataJustAnyField), null);
  });

  test('Should return error if values are not equal', () {
    final formData = {'any_field': 'any_value', 'other_field': 'other_value'};
    expect(sut.validate(input: formData), ValidationError.invalidField);
  });

  test('Should return null if values are equal', () {
    final formData = {'any_field': 'any_value', 'other_field': 'any_value'};
    expect(sut.validate(input: formData), null);
  });
}
