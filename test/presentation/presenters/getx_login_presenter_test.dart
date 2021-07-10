import 'package:clean_architecture/app/domain/entities/entities.dart';
import 'package:clean_architecture/app/domain/helpers/helpers.dart';
import 'package:clean_architecture/app/domain/usecases/usecases.dart';
import 'package:clean_architecture/app/presentation/presenters/presenters.dart';
import 'package:clean_architecture/app/presentation/protocols/protocols.dart';
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
          field: field ?? anyNamed('field'), value: anyNamed('value')));

  void mockValidation({@required String field, @required String value}) {
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

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationImplSpy();
    saveCurrentAccount = SaveCurrentAccountImplSpy();
    sut = GetxLoginPresenter(
      validation: validation,
      authentication: authentication,
      saveCurrentAccount: saveCurrentAccount,
    );
    email = faker.internet.email();
    password = faker.internet.password();
    token = faker.guid.guid();

    // ! Mock sucesso quando passsar null null
    mockValidation(field: null, value: null);
    mockAuthentication();
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email: email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit error if validation fails', () {
    mockValidation(field: null, value: 'error');

    // ! Espera até acontecer ou dar timeout
    expectLater(sut.emailError.stream, emits('error'));

    // ? Execução pós expectativa
    sut.validateEmail(email: email);
  });

  test('Should emit error if validation fails - Twice Array', () {
    mockValidation(field: null, value: 'error');

    // ! Espera até acontecer ou dar timeout
    expectLater(sut.emailError.stream, emitsInOrder(['error']));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateEmail(email: email);
    sut.validateEmail(email: email);
  });

  test('Should emit error if validation fails - Twice Distinct', () {
    mockValidation(field: null, value: 'error');

    // ! Quando se tem apenas um parametro pode usar direto
    // sut.emailErrorStream.listen((error) {
    //   expectAsync1((error) => expect(error, 'error'));
    // });
    sut.emailError.listen(expectAsync1((error) => expect(error, 'error')));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateEmail(email: email);
    sut.validateEmail(email: email);
  });

  test('Should isFormValid emits false if email is invalid ', () {
    mockValidation(field: null, value: 'error');

    sut.emailError.listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateEmail(email: email);
    sut.validateEmail(email: email);
  });

  test('Should emit null if validation succeeds', () {
    sut.emailError.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateEmail(email: email);
    sut.validateEmail(email: email);
  });

  test('Should call Validation with correct password', () {
    sut.validatePassword(password: password);

    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(field: null, value: 'error');

    sut.passwordError.listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validatePassword(password: password);
    sut.validatePassword(password: password);
  });

  test('Should emits form invalid  if any fields is invalid', () {
    mockValidation(field: 'email', value: 'error');

    sut.emailError.listen(expectAsync1((error) => expect(error, 'error')));
    sut.passwordError.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateEmail(email: email);
    sut.validatePassword(password: password);
  });

  test('Should emits form valid event if form is valid', () async {
    sut.emailError.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordError.listen(expectAsync1((error) => expect(error, null)));

    expectLater(sut.isFormValid.stream, emitsInOrder([false, true]));

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

  test('Should call SaveCurrentAccount with correct value', () async {
    sut.validateEmail(email: email);
    sut.validatePassword(password: password);

    await sut.auth();

    verify(saveCurrentAccount.save(AccountEntity(token: token))).called(1);
  });

  test('Should emit correct events on Authentication success', () async {
    sut.validateEmail(email: email);
    sut.validatePassword(password: password);

    expectLater(sut.isLoading.stream, emitsInOrder([true, false]));

    await sut.auth();
  });

  test('Should emit correct events on InvalidCredentialsError', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email: email);
    sut.validatePassword(password: password);

    expectLater(sut.isLoading.stream, emitsInOrder([true, false]));

    sut.mainError.listen(
        expectAsync1((error) => expect(error, 'Credenciais inválidas.')));

    await sut.auth();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email: email);
    sut.validatePassword(password: password);

    expectLater(sut.isLoading.stream, emitsInOrder([true, false]));

    sut.mainError.listen(expectAsync1((error) =>
        expect(error, 'Algo errado aconteceu. Tente novamente em breve.')));

    await sut.auth();
  });
}
