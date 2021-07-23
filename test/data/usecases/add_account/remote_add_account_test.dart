import 'package:clean_architecture/app/data/http/http.dart';
import 'package:clean_architecture/app/data/usecases/usecases.dart';
import 'package:clean_architecture/app/domain/helpers/helpers.dart';
import 'package:clean_architecture/app/domain/usecases/usecases.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAddAccount sut;
  HttpClient httpClient;
  Uri url;
  AddAccountParams params;

  PostExpectation mockRequest() => when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body')));

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
    url = Uri.parse(faker.internet.httpsUrl());
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
    params = AddAccountParams(
      name: faker.person.name(),
      email: faker.internet.email(),
      password: faker.internet.password(),
      passwordConfirmation: faker.internet.password(),
    );
    mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.add(params: params);

    verify(
      httpClient.request(url: url, method: 'post', body: {
        'name': params.name,
        'email': params.email,
        'password': params.password,
        'passwordConfirmation': params.passwordConfirmation,
      }),
    );
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    mockHttpError(HttpError.badRequest);
    final future = sut.add(params: params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);
    final future = sut.add(params: params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);
    final future = sut.add(params: params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 403',
      () async {
    mockHttpError(HttpError.forbidden);
    final future = sut.add(params: params);
    expect(future, throwsA(DomainError.emailInUse));
  });

  test('Should return an Account if HttpClient returns 200', () async {
    final validData = mockValidData();
    mockHttpData(validData);

    final account = await sut.add(params: params);

    expect(account.token, validData['accessToken']);
  });

  test('Should throw Unexpected if HttpClient returns 200 with invalid data',
      () async {
    mockRequest().thenAnswer((_) async => {'invalid_key': 'invalid_value'});
    final future = sut.add(params: params);
    expect(future, throwsA(DomainError.unexpected));
  });
}
