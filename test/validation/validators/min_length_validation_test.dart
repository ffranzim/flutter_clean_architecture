import 'package:clean_architecture/app/presentation/protocols/validation.dart';
import 'package:clean_architecture/app/validation/validators/validators.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  MinLengthValidation sut;
  setUp(() {
    sut = const MinLengthValidation(field: 'any_field', minSize: 5);
  });

  test('Should return error if value is empty', () {
    final formData = {'any_field': ''};
    final error = sut.validate(input: formData);
    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    final formData = {'any_field': null};
    final error = sut.validate(input: formData);
    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is less than min size ', () {
    final formData = {'any_field': faker.randomGenerator.string(4, min: 1)};

    final error = sut.validate(input: formData);

    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is equal than min size ', () {
    final formData = {'any_field': faker.randomGenerator.string(5, min: 5)};

    final error = sut.validate(input: formData);

    expect(error, null);
  });

  test('Should return error if value is bigger than min size ', () {

    final formData = {'any_field': faker.randomGenerator.string(10, min: 6)};

    final error = sut.validate(input: formData);

    expect(error, null);
  });
}
