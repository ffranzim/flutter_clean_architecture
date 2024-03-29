import 'package:clean_architecture/app/domain/entities/account_entity.dart';
import 'package:clean_architecture/app/domain/helpers/helpers.dart';
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
  Authetication authentication;
  SaveCurrentAccount saveCurrentAccount;
  GetxLoginPresenter sut;
  String email;
  String password;
  String token;

  PostExpectation mockValidationCall({@required String field}) =>
      when(validation.validate(
          field: field ?? anyNamed('field'), input: anyNamed('input')));

  void mockValidation(
      {@required String field, @required ValidationError value}) {
    mockValidationCall(field: field).thenReturn(value);
  }

  PostExpectation mockAuthenticationCall() =>
      when(authentication.auth(params: anyNamed('params')));

  void mockAuthentication() {
    // ? thenAnswer utilizado para assincronos
    mockAuthenticationCall()
        .thenAnswer((_) async => AccountEntity(token: token));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  PostExpectation mockSaveCurrentAccountCall() =>
      when(saveCurrentAccount.saveSecure(account: anyNamed('account')));

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationImplSpy();
    saveCurrentAccount = SaveCurrentAccountImplSpy();
    sut = GetxLoginPresenter(
        validation: validation,
        authentication: authentication,
        saveCurrentAccount: saveCurrentAccount);
    email = faker.internet.email();
    password = faker.internet.password();
    password = faker.guid.guid();

    // ! Mock sucesso quando passsar null null
    mockValidation(field: null, value: null);
    mockAuthentication();
  });

  test('Should call Validation with correct email', () {
    final formData = {'email': email, 'password': null};

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

  test('Should emit error if validation fails - Twice Array', () {
    mockValidation(field: null, value: ValidationError.invalidField);

    // ! Espera até acontecer ou dar timeout
    expectLater(sut.emailErrorStream, emitsInOrder([UIError.invalidField]));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateEmail(email: email);
    sut.validateEmail(email: email);
  });

  test('Should emit error if validation fails - Twice Distinct', () {
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

  test('Should emit null if validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateEmail(email: email);
    sut.validateEmail(email: email);
  });

  test('Should call Validation with correct password', () {
    final formData = {'password': password, 'email': null};

    sut.validatePassword(password: password);

    verify(validation.validate(field: 'password', input: formData)).called(1);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(field: null, value: ValidationError.invalidField);

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro

    sut.validatePassword(password: password);
    sut.validatePassword(password: password);
  });

  test('Should emits form invalid  if any fields is invalid', () {
    mockValidation(field: 'email', value: ValidationError.invalidField);

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(null, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateEmail(email: email);
    sut.validatePassword(password: password);
  });

  test('Should emits form valid event if form is valid', () async {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateEmail(email: email);
    // ! Delayed espera a tela montar, senao dá erro
    await Future.delayed(Duration.zero);
    sut.validatePassword(password: password);
  });

  test('Should call Authentication with correct values', () async {
    sut.validateEmail(email: email);
    sut.validatePassword(password: password);

    await sut.auth();

    verify(authentication.auth(
            params: AuthenticationParams(email: email, secret: password)))
        .called(1);
  });

  test('Should emit correct events on Authentication success', () async {
    sut.validateEmail(email: email);
    sut.validatePassword(password: password);

    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.isLoadingStream, emits(true));

    await sut.auth();
  });

  test('Should emit correct events on InvalidCredentialsError', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email: email);
    sut.validatePassword(password: password);

    // ? aparentemente se perde no teste(try catch) com stream
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    // ! verifica só o estado final para verificar algo
    // expectLater(sut.isLoadingStream, emits(false));


    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.invalidCredentials]));

    // sut.mainErrorStream.listen(
    //     expectAsync1((error) => expect(error, UIError.invalidCredentials)));

    await sut.auth();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email: email);
    sut.validatePassword(password: password);

    // ? aparentemente se perde no teste(try catch) com stream
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    // ! verifica só o estado final para verificar algo
    // expectLater(sut.isLoadingStream, emits(false));

    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.auth();
  });

  test('Should call SaveCurrentAccount with correct value', () async {
    sut.validateEmail(email: email);
    sut.validatePassword(password: password);

    await sut.auth();

    verify(saveCurrentAccount.saveSecure(account: AccountEntity(token: token)))
        .called(1);
  });

  test('Should emit UnexpectedError if SaveCurrentAccount fails', () async {
    mockSaveCurrentAccountError();
    sut.validateEmail(email: email);
    sut.validatePassword(password: password);

    // ? aparentemente se perde no teste(try catch) com stream
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    // ! verifica só o estado final para verificar algo
    // expectLater(sut.isLoadingStream, emits(false));

    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.auth();
  });

  test('Should change page on success', () async {
    sut.validateEmail(email: email);
    sut.validatePassword(password: password);

    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.auth();

    verify(saveCurrentAccount.saveSecure(account: AccountEntity(token: token)))
        .called(1);
  });

  test('Should goToSignUp page on link click', () async {
    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/signup')));
    sut.goToSignUp();
  });
}
