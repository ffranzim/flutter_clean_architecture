import 'package:clean_architecture/app/data/http/http.dart';
import 'package:clean_architecture/app/data/usecases/remote_authetication.dart';
import 'package:clean_architecture/app/domain/helpers/helpers.dart';
import 'package:clean_architecture/app/domain/usecases/authentication.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';

import 'package:mocktail/mocktail.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthetication sut;
  late HttpClient httpClient;
  late String url;
  late AuthenticationParams params;

  When<Future<Map<dynamic, dynamic>>> mockRequest() =>
      when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body')));

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  Map mockValidData() =>
      {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpsUrl();
    sut = RemoteAuthetication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
    mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.auth(params);

    verify(
      () => httpClient.request(
          url: url,
          method: 'post',
          body: {'email': params.email, 'password': params.secret}),
    );
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    mockHttpError(HttpError.badRequest);
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 401',
      () async {

    mockHttpError(HttpError.unauthorized);
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an Account if HttpClient returns 200', () async {
    final validData = mockValidData();
    mockRequest().thenAnswer((_) async => validData);
    final account = await sut.auth(params);
    expect(account.token, validData['accessToken']);
  });

  test('Should throw Unexpected if HttpClient returns 200 with invalid data',
      () async {

    mockRequest().thenAnswer((_) async => {'invalid_key': 'invalid_value'});
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });
}
