import 'package:clean_architecture/app/presentation/protocols/protocols.dart';
import 'package:clean_architecture/app/validation/validators/required_field_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  RequiredFieldValidation sut;

  setUp(() {
    sut = const RequiredFieldValidation(field: 'any_field');
  });

  test('Should return null if value is not empty', () {
    final formData = {'any_field': 'any_value'};

    final error = sut.validate(input: formData);

    expect(error, null);
  });

  test('Should return error if value is empty', () {
    final formData = {'any_field': ''};

    final error = sut.validate(input: formData);

    expect(error, ValidationError.requiredField);
  });

  test('Should return error if value is null', () {
    final formData = {'any_field': null};

    final error = sut.validate(input: formData);

    expect(error, ValidationError.requiredField);
  });
}
