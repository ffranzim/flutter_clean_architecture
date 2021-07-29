import 'package:clean_architecture/app/presentation/protocols/validation.dart';
import 'package:clean_architecture/app/validation/protocols/field_validation.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

class MinLengthValidation implements FieldValidation {
  final String field;
  final int minSize;

  MinLengthValidation({@required this.field, @required this.minSize});

  @override
  ValidationError validate({String value}) {
    if (value == null || value.length < minSize) {
      return ValidationError.invalidField;
    }
    return null;
  }
}

void main() {
  MinLengthValidation sut;
  setUp(() {
    sut = MinLengthValidation(field: 'any_field', minSize: 5);
  });

  test('Should return error if value is empty', () {
    final error = sut.validate(value: '');
    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    final error = sut.validate(value: null);
    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is less than min size ', () {
    final error = sut.validate(value: faker.randomGenerator.string(4, min: 1));
    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is equal than min size ', () {
    final error = sut.validate(value: faker.randomGenerator.string(5, min: 5));
    expect(error, null);
  });
}
