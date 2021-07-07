import 'package:clean_architecture/app/main/factories/factories.dart';
import 'package:clean_architecture/app/validation/protocols/field_validation.dart';
import 'package:clean_architecture/app/validation/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Shoukld return the correct validations', () {
    final validations = makeLoginValidations();


    final fieldsValidation = <FieldValidation> [
      const RequiredFieldValidation(field: 'email'),
      const EmailValidation(field: 'email'),
      const RequiredFieldValidation(field: 'password'),
    ];

    expect(validations, fieldsValidation);
  });
}
