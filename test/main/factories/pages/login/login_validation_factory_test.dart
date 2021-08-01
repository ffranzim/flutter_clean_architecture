import 'package:clean_architecture/app/main/factories/factories.dart';
import 'package:clean_architecture/app/validation/protocols/field_validation.dart';
import 'package:clean_architecture/app/validation/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should return the correct validations', () {
    final validations = makeLoginValidations();


    final fieldsValidation = <FieldValidation> [
      const RequiredFieldValidation(field: 'email'),
      const EmailValidation(field: 'email'),
      const RequiredFieldValidation(field: 'password'),
      const MinLengthValidation(field: 'password', minSize: 3),
      // const RequiredFieldValidation(field: 'passwordConfirmation'),
      // const MinLengthValidation(field: 'passwordConfirmation', minSize: 3),
      // CompareFieldsValidation(field: 'password', fieldToCompare: 'passwordConfirmation')
    ];

    expect(validations, fieldsValidation);
  });
}
