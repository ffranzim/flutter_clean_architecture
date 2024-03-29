import 'package:clean_architecture/app/domain/entities/entities.dart';
import 'package:clean_architecture/app/domain/helpers/domain_error.dart';
import 'package:clean_architecture/app/domain/usecases/usecases.dart';
import 'package:clean_architecture/app/presentation/presenters/presenters.dart';
import 'package:clean_architecture/app/presentation/protocols/protocols.dart';
import 'package:clean_architecture/app/ui/helpers/errors/errors.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ValidationSpy extends Mock implements Validation {}

class AddAccountSpy extends Mock implements AddAccount {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  Validation validation;
  AddAccount addAccount;
  SaveCurrentAccount saveCurrentAccount;
  GetxSignUpPresenter sut;
  String email;
  String name;
  String password;
  String passwordConfirmation;
  String token;

  PostExpectation mockValidationCall({@required String field}) =>
      when(validation.validate(
          field: field ?? anyNamed('field'), input: anyNamed('input')));

  PostExpectation mockAddAccountCall() =>
      when(addAccount.add(params: anyNamed('params')));

  void mockAddAccount() {
    mockAddAccountCall().thenAnswer((_) async => AccountEntity(token: token));
  }

  void mockValidation(
      {@required String field, @required ValidationError value}) {
    mockValidationCall(field: field).thenReturn(value);
  }

  PostExpectation mockSaveCurrentAccountCall() =>
      when(saveCurrentAccount.saveSecure(account: anyNamed('account')));

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  }

  void mockAddAccountError(DomainError error) {
    mockAddAccountCall().thenThrow(error);
  }

  setUp(() {
    validation = ValidationSpy();
    addAccount = AddAccountSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxSignUpPresenter(
      validation: validation,
      addAccount: addAccount,
      saveCurrentAccount: saveCurrentAccount,
    );
    email = faker.internet.email();
    name = faker.person.name();
    password = faker.internet.password(length: 8);
    passwordConfirmation = faker.internet.password(length: 8);
    token = faker.guid.guid();
    // ! Mock sucesso quando passsar null null
    mockValidation(field: null, value: null);
    mockAddAccount();
  });

  test('Should call Validation with correct email', () {
    final formData = {'email': email, 'name': null, 'password': null, 'passwordConfirmation': null};

    sut.validateEmail(email: email);

    verify(validation.validate(field: 'email', input: formData)).called(1);
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

  test('Should emit error if validation fails - Twice Array - Validate Email',
      () {
    mockValidation(field: null, value: ValidationError.invalidField);

    // ! Espera até acontecer ou dar timeout
    expectLater(sut.emailErrorStream, emitsInOrder([UIError.invalidField]));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateEmail(email: email);
    sut.validateEmail(email: email);
  });

  test(
      'Should emit error if validation fails - Twice Distinct - Validate Email',
      () {
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
    final formData = {
      'email': null,
      'name': name,
      'password': null,
      'passwordConfirmation': null,
    };
    sut.validateName(name: name);

    verify(validation.validate(field: 'name', input: formData)).called(1);
  });

  test('Should emit invalidFieldError if name validation fails', () {
    mockValidation(field: null, value: ValidationError.invalidField);

    // ! Espera até acontecer ou dar timeout
    expectLater(sut.nameErrorStream, emits(UIError.invalidField));

    // ? Execução pós expectativa
    sut.validateName(name: name);
  });

  test('Should emit invalidFieldError if name validation fails - Validate Name',
      () {
    mockValidation(field: null, value: ValidationError.requiredField);

    // ! Espera até acontecer ou dar timeout
    expectLater(sut.nameErrorStream, emits(UIError.requiredField));

    // ? Execução pós expectativa
    sut.validateName(name: name);
  });

  test('Should emit error if validation fails - Twice Array - Validate Name',
      () {
    mockValidation(field: null, value: ValidationError.invalidField);

    // ! Espera até acontecer ou dar timeout
    expectLater(sut.nameErrorStream, emitsInOrder([UIError.invalidField]));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateName(name: name);
    sut.validateName(name: name);
  });

  test('Should emit error if validation fails - Twice Distinct - Validate Name',
      () {
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

  // ! Password Validation

  test('Should call Validation with correct password', () {
    final formData = {
      'email': null,
      'name': null,
      'password': password,
      'passwordConfirmation': null,
    };
    sut.validatePassword(password: password);

    verify(validation.validate(field: 'password', input: formData)).called(1);
  });

  test('Should emit invalidFieldError if password validation fails', () {
    mockValidation(field: null, value: ValidationError.invalidField);

    // ! Espera até acontecer ou dar timeout
    expectLater(sut.passwordErrorStream, emits(UIError.invalidField));

    // ? Execução pós expectativa
    sut.validatePassword(password: password);
  });

  test(
      'Should emit invalidFieldError if name validation fails - Validate Password',
      () {
    mockValidation(field: null, value: ValidationError.requiredField);

    // ! Espera até acontecer ou dar timeout
    expectLater(sut.passwordErrorStream, emits(UIError.requiredField));

    // ? Execução pós expectativa
    sut.validatePassword(password: password);
  });

  test(
      'Should emit error if validation fails - Twice Array - Validate Password',
      () {
    mockValidation(field: null, value: ValidationError.invalidField);

    // ! Espera até acontecer ou dar timeout
    expectLater(sut.passwordErrorStream, emitsInOrder([UIError.invalidField]));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validatePassword(password: password);
    sut.validatePassword(password: password);
  });

  test(
      'Should emit error if validation fails - Twice Distinct - Validate Password',
      () {
    mockValidation(field: null, value: ValidationError.invalidField);

    // ! Quando se tem apenas um parametro pode usar direto
    // sut.emailErrorStream.listen((error) {
    //   expectAsync1((error) => expect(error, 'error'));
    // });
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validatePassword(password: password);
    sut.validatePassword(password: password);
  });

  test('Should isFormValid emits false if password is invalid ', () {
    mockValidation(field: null, value: ValidationError.invalidField);

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validatePassword(password: password);
    sut.validatePassword(password: password);
  });

  test('Should emit null if validation succeeds - Validate Password', () {
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validatePassword(password: password);
    sut.validatePassword(password: password);
  });

  // ! passwordConfirmation Validation

  test('Should call Validation with correct PasswordConfirmation', () {
    final formData = {
      'name': null,
      'email': null,
      'password': null,
      'passwordConfirmation': passwordConfirmation,
    };

    sut.validatePasswordConfirmation(
        passwordConfirmation: passwordConfirmation);

    verify(validation.validate(
            field: 'passwordConfirmation', input: formData))
        .called(1);
  });

  test('Should emit invalidFieldError if passwordConfirmation validation fails',
      () {
    mockValidation(field: null, value: ValidationError.invalidField);

    // ! Espera até acontecer ou dar timeout
    expectLater(
        sut.passwordConfirmationErrorStream, emits(UIError.invalidField));

    // ? Execução pós expectativa
    sut.validatePasswordConfirmation(passwordConfirmation: password);
  });

  test(
      'Should emit invalidFieldError if name validation fails - Validate PasswordConfirmation',
      () {
    mockValidation(field: null, value: ValidationError.requiredField);

    // ! Espera até acontecer ou dar timeout
    expectLater(
        sut.passwordConfirmationErrorStream, emits(UIError.requiredField));

    // ? Execução pós expectativa
    sut.validatePasswordConfirmation(passwordConfirmation: password);
  });

  test(
      'Should emit error if validation fails - Twice Array - Validate PasswordConfirmation',
      () {
    mockValidation(field: null, value: ValidationError.invalidField);

    // ! Espera até acontecer ou dar timeout
    expectLater(sut.passwordConfirmationErrorStream,
        emitsInOrder([UIError.invalidField]));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validatePasswordConfirmation(passwordConfirmation: password);
    sut.validatePasswordConfirmation(passwordConfirmation: password);
  });

  test(
      'Should emit error if validation fails - Twice Distinct - Validate PasswordConfirmation',
      () {
    mockValidation(field: null, value: ValidationError.invalidField);

    // ! Quando se tem apenas um parametro pode usar direto
    // sut.emailErrorStream.listen((error) {
    //   expectAsync1((error) => expect(error, 'error'));
    // });
    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validatePasswordConfirmation(passwordConfirmation: password);
    sut.validatePasswordConfirmation(passwordConfirmation: password);
  });

  test('Should isFormValid emits false if PasswordConfirmation is invalid ',
      () {
    mockValidation(field: null, value: ValidationError.invalidField);

    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validatePasswordConfirmation(
        passwordConfirmation: passwordConfirmation);
    sut.validatePasswordConfirmation(
        passwordConfirmation: passwordConfirmation);
  });

  test(
      'Should emit null if validation succeeds - Validate PasswordConfirmation',
      () {
    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validatePasswordConfirmation(passwordConfirmation: password);
    sut.validatePasswordConfirmation(passwordConfirmation: password);
  });

  // ! IsFormValid Validation

  test('should enable form button if all fields are valid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateEmail(email: email);
    // ! Delayed espera a tela montar, senao dá erro
    await Future.delayed(Duration.zero);
    sut.validateName(name: name);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password: password);
    await Future.delayed(Duration.zero);
    sut.validatePasswordConfirmation(
        passwordConfirmation: passwordConfirmation);
  });

  test('Should call AddAccount with correct value', () async {
    sut.validateEmail(email: email);
    sut.validateName(name: name);
    sut.validatePassword(password: password);
    sut.validatePasswordConfirmation(
        passwordConfirmation: passwordConfirmation);

    await sut.signUp();

    verify(
      addAccount.add(
        params: AddAccountParams(
            name: name,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation),
      ),
    ).called(1);
  });

  test('Should call SaveCurrentAccount with correct value', () async {
    await sut.signUp();

    verify(
      saveCurrentAccount.saveSecure(
        account: AccountEntity(token: token),
      ),
    ).called(1);
  });

  test('Should emit UnexpectedError if SaveCurrentAccount fails', () async {
    mockSaveCurrentAccountError();

    // ? aparentemente se perde no teste(try catch) com stream
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.signUp();
  });

  test('Should emit corect events on AddAccount success', () async {
    expectLater(sut.isLoadingStream, emits(true));
    expectLater(sut.mainErrorStream, emits(null));
    await sut.signUp();
  });

  test('Should emit correct events on EmailInUseError', () async {
    mockAddAccountError(DomainError.emailInUse);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.emailInUse]));

    await sut.signUp();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockAddAccountError(DomainError.unexpected);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));


    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.signUp();
  });

  test('Should change page on success', () async {
    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.signUp();

    verify(saveCurrentAccount.saveSecure(account: AccountEntity(token: token)))
        .called(1);
  });

  test('Should go to LoginPage on link click', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));
    sut.goToLogin();
  });
}
