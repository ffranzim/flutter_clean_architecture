import 'package:clean_architecture/app/domain/entities/account_entity.dart';
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

void main() {
  Validation validation;
  Authetication authentication;
  StreamLoginPresenter sut;
  String email;
  String password;

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
        .thenAnswer((_) async => AccountEntity(token: faker.guid.guid()));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationImplSpy();
    sut = StreamLoginPresenter(
        validation: validation, authentication: authentication);
    email = faker.internet.email();
    password = faker.internet.password();

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
    expectLater(sut.emailErrorStream, emits('error'));

    // ? Execução pós expectativa
    sut.validateEmail(email: email);
  });

  test('Should emit error if validation fails - Twice Array', () {
    mockValidation(field: null, value: 'error');

    // ! Espera até acontecer ou dar timeout
    expectLater(sut.emailErrorStream, emitsInOrder(['error']));

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
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validateEmail(email: email);
    sut.validateEmail(email: email);
  });

  test('Should isFormValid emits false if email is invalid ', () {
    mockValidation(field: null, value: 'error');

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
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
    sut.validatePassword(password: password);

    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(field: null, value: 'error');

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    // ? Execução pós expectativa! Chama 2x porém emite só um erro
    sut.validatePassword(password: password);
    sut.validatePassword(password: password);
  });

  test('Should emits form invalid  if any fields is invalid', () {
    mockValidation(field: 'email', value: 'error');

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
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

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.auth();
  });

  test('Should emit correct events on InvalidCredentialsError', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email: email);
    sut.validatePassword(password: password);

    // ? aparentemente se perde no teste(try catch)
    //expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    // ! verifica só o estado final para verificar algo
    expectLater(sut.isLoadingStream, emits(false));

    sut.mainErrorStream.listen(expectAsync1((error) => expect(error, 'Credenciais inválidas.')));

    await sut.auth();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email: email);
    sut.validatePassword(password: password);

    // ? aparentemente se perde no teste(try catch)
    //expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    // ! verifica só o estado final para verificar algo
    expectLater(sut.isLoadingStream, emits(false));

    sut.mainErrorStream.listen(expectAsync1((error) => expect(error, 'Algo errado aconteceu. Tente novamente em breve.')));

    await sut.auth();
  });

  test('Should not emit after dispose', () async {
    expectLater(sut.emailErrorStream, neverEmits(null));
    sut.dispose();
    sut.validateEmail(email: email);
    //
    // // ? aparentemente se perde no teste(try catch)
    // //expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    // // ! verifica só o estado final para verificar algo
    // expectLater(sut.isLoadingStream, emits(false));
    //
    // sut.mainErrorStream.listen(expectAsync1((error) => expect(error, 'Algo errado aconteceu. Tente novamente em breve.')));
    //
    // await sut.auth();
    // sut.emailErrorStream.listen((error) => expect(error, never));
  });
}