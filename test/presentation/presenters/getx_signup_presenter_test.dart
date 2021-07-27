import 'package:clean_architecture/app/domain/usecases/usecases.dart';
import 'package:clean_architecture/app/presentation/presenters/presenters.dart';
import 'package:clean_architecture/app/presentation/protocols/protocols.dart';
import 'package:clean_architecture/app/ui/helpers/errors/errors.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationImplSpy extends Mock implements Authetication {}

class SaveCurrentAccountImplSpy extends Mock implements SaveCurrentAccount {}

void main() {
  Validation validation;
  GetxSignUpPresenter sut;
  String email;

  PostExpectation mockValidationCall({@required String field}) =>
      when(validation.validate(
          field: field ?? anyNamed('field'), value: anyNamed('value')));

  void mockValidation(
      {@required String field, @required ValidationError value}) {
    mockValidationCall(field: field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = GetxSignUpPresenter(
      validation: validation,
    );
    email = faker.internet.email();
    // ! Mock sucesso quando passsar null null
    mockValidation(field: null, value: null);
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email: email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit invalidFieldError if email validation fails', () {
    mockValidation(field: null, value: ValidationError.invalidField);

    // ! Espera até acontecer ou dar timeout
    expectLater(sut.emailErrorStream, emits(UIError.invalidField));

    // ? Execução pós expectativa
    sut.validateEmail(email: email);
  });

  test('Should emit invalidFieldError if email validation fails', () {
    mockValidation(field: null, value: ValidationError.requiredField);

    // ! Espera até acontecer ou dar timeout
    expectLater(sut.emailErrorStream, emits(UIError.requiredField));

    // ? Execução pós expectativa
    sut.validateEmail(email: email);
  });

  test('Should emit error  if validation fails - Twice Array', () {
    mockValidation(field: null, value: ValidationError.invalidField);

    // ! Espera até acontecer ou dar timeout
    expectLater(sut.emailErrorStream, emitsInOrder([UIError.invalidField]));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateEmail(email: email);
    sut.validateEmail(email: email);
  });
}
