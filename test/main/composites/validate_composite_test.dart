import 'package:clean_architecture/app/presentation/protocols/protocols.dart';
import 'package:clean_architecture/app/validation/protocols/protocols.dart';
import 'package:clean_architecture/app/main/composites/composites.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  ValidationComposite sut;
  FieldValidationSpy validaton1;
  FieldValidationSpy validaton2;
  FieldValidationSpy validaton3;

  void mockValidation(
      {@required FieldValidation validation, @required ValidationError error}) {
    when(validation.validate(input: anyNamed('input'))).thenReturn(error);
  }

  setUp(() {
    sut = ValidationComposite(validations: []);

    validaton1 = FieldValidationSpy();
    when(validaton1.field).thenReturn('any_field');
    mockValidation(validation: validaton1, error: null);

    validaton2 = FieldValidationSpy();
    when(validaton2.field).thenReturn('other_field');
    mockValidation(validation: validaton2, error: null);

    validaton3 = FieldValidationSpy();
    when(validaton3.field).thenReturn('any_field');
    mockValidation(validation: validaton3, error: null);

    sut =
        ValidationComposite(validations: [validaton1, validaton2, validaton3]);
  });

  test('Should return null if value all validations return null or empty', () {
    final error = sut.validate(field: 'any_field',input: {});

    expect(error, null);
  });

  test('Should return error if value all validations return is not empty', () {
    mockValidation(validation: validaton1, error: ValidationError.requiredField);
    mockValidation(validation: validaton2, error: ValidationError.requiredField);
    mockValidation(validation: validaton3, error: ValidationError.invalidField);

    final error = sut.validate(field: 'any_field',input: {});

    expect(error, ValidationError.requiredField);
  });

  test('Should return the first error', () {
    mockValidation(
        validation: validaton1, error: ValidationError.invalidField);
    mockValidation(validation: validaton2, error: ValidationError.requiredField);
    mockValidation(validation: validaton3, error: ValidationError.requiredField);

    final error = sut.validate(field: 'any_field',input: {});

    expect(error, ValidationError.invalidField);
  });
}
