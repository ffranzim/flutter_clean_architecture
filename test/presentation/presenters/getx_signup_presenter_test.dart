import 'package:clean_architecture/app/presentation/presenters/presenters.dart';
import 'package:clean_architecture/app/presentation/protocols/protocols.dart';
import 'package:clean_architecture/app/ui/helpers/errors/errors.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  Validation validation;
  GetxSignUpPresenter sut;
  String email;
  String name;

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
    name = faker.person.name();
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

  test('Should emit error if validation fails - Twice Array - Validate Email', () {
    mockValidation(field: null, value: ValidationError.invalidField);

    // ! Espera até acontecer ou dar timeout
    expectLater(sut.emailErrorStream, emitsInOrder([UIError.invalidField]));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateEmail(email: email);
    sut.validateEmail(email: email);
  });

  test('Should emit error if validation fails - Twice Distinct - Validate Email', () {
    mockValidation(field: null, value: ValidationError.invalidField);

    // ! Quando se tem apenas um parametro pode usar direto
    // sut.emailErrorStream.listen((error) {
    //   expectAsync1((error) => expect(error, 'error'));
    // });
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateEmail(email: email);
    sut.validateEmail(email: email);
  });

  test('Should isFormValid emits false if email is invalid ', () {
    mockValidation(field: null, value: ValidationError.invalidField);

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateEmail(email: email);
    sut.validateEmail(email: email);
  });

  test('Should emit null if validation succeeds - Validate Email', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateEmail(email: email);
    sut.validateEmail(email: email);
  });

  // ! Name Validation

  test('Should call Validation with correct name', () {
    sut.validateName(name: name);

    verify(validation.validate(field: 'name', value: name)).called(1);
  });

  test('Should emit invalidFieldError if name validation fails', () {
    mockValidation(field: null, value: ValidationError.invalidField);

    // ! Espera até acontecer ou dar timeout
    expectLater(sut.nameErrorStream, emits(UIError.invalidField));

    // ? Execução pós expectativa
    sut.validateName(name: name);
  });

  test('Should emit invalidFieldError if name validation fails - Validate Name', () {
    mockValidation(field: null, value: ValidationError.requiredField);

    // ! Espera até acontecer ou dar timeout
    expectLater(sut.nameErrorStream, emits(UIError.requiredField));

    // ? Execução pós expectativa
    sut.validateName(name: name);
  });

  test('Should emit error if validation fails - Twice Array - Validate Name', () {
    mockValidation(field: null, value: ValidationError.invalidField);

    // ! Espera até acontecer ou dar timeout
    expectLater(sut.nameErrorStream, emitsInOrder([UIError.invalidField]));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateName(name: name);
    sut.validateName(name: name);
  });

  test('Should emit error if validation fails - Twice Distinct - Validate Name', () {
    mockValidation(field: null, value: ValidationError.invalidField);

    // ! Quando se tem apenas um parametro pode usar direto
    // sut.emailErrorStream.listen((error) {
    //   expectAsync1((error) => expect(error, 'error'));
    // });
    sut.nameErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateName(name: name);
    sut.validateName(name: name);
  });

  test('Should isFormValid emits false if name is invalid ', () {
    mockValidation(field: null, value: ValidationError.invalidField);

    sut.nameErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateName(name: name);
    sut.validateName(name: name);
  });

  test('Should emit null if validation succeeds - Validate Name', () {
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateName(name: name);
    sut.validateName(name: name);
  });

  // ! Outro Validation
}
