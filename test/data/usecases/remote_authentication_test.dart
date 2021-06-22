import 'package:clean_architecture/app/data/http/http.dart';
import 'package:clean_architecture/app/data/usecases/remote_authetication.dart';
import 'package:clean_architecture/app/domain/helpers/helpers.dart';
import 'package:clean_architecture/app/domain/usecases/authentication.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail/mocktail.dart' as mocktail;

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthetication sut;
  HttpClient httpClient;
  String url;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpsUrl();
    sut = RemoteAuthetication(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with correct values', () async {
    final params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
    await sut.auth(params);
    verify(
      httpClient.request(
          url: url,
          method: 'post',
          body: {'email': params.email, 'password': params.secret}),
    );
  });

  test('Should throw UnexpectedError if HttpClien returns 400', () async {
    when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);

    final params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
