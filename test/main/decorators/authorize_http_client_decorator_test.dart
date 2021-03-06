import 'package:clean_architecture/app/data/cache/cache.dart';
import 'package:clean_architecture/app/data/http/http.dart';
import 'package:clean_architecture/app/main/decorators/decorators.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  HttpClient httpClient;
  AuthorizeHttpClientDecorator sut;
  Uri url;
  String method;
  Map body;
  String token;
  String httpResponse;

  PostExpectation<Future<String>> mockTokenCall(
          FetchSecureCacheStorageSpy fetchSecureCacheStorage) =>
      when(fetchSecureCacheStorage.fetchSecure(key: anyNamed('key')));

  void mockToken() {
    token = faker.guid.guid();
    mockTokenCall(fetchSecureCacheStorage).thenAnswer((_) async => token);
  }

  void mockTokenError() {
    token = faker.guid.guid();
    mockTokenCall(fetchSecureCacheStorage).thenThrow(Exception());
  }

  PostExpectation<Future> mockReponseCall() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      ));

  void mockHttpResponse() {
    httpResponse = faker.randomGenerator.string(50);
    mockReponseCall().thenAnswer((_) async => httpResponse);
  }

  void mockHttpResponseError(error) {
    mockReponseCall().thenThrow(error);
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    httpClient = HttpClientSpy();
    sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
      decoratee: httpClient,
    );
    url = Uri.parse(faker.internet.httpUrl());
    method = faker.randomGenerator.string(4);
    body = {'any_key': 'any_value'};
    mockToken();
    mockHttpResponse();
  });

  test('Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: url, method: method, body: body);

    verify(fetchSecureCacheStorage.fetchSecure(key: anyNamed('key'))).called(1);
  });

  test('Should call decoratee with access token on header', () async {
    await sut.request(url: url, method: method, body: body);
    verify(httpClient.request(
      url: url,
      method: method,
      body: body,
      headers: {'x-access-token': token},
    )).called(1);

    await sut.request(url: url, method: method, body: body, headers: {'any_header': 'any_value'});
    verify(httpClient.request(
      url: url,
      method: method,
      body: body,
      headers: {'x-access-token': token, 'any_header': 'any_value'},
    )).called(1);
  });

  test('Should return same result as decoratee', () async {
    final response = await sut.request(url: url, method: method, body: body);

    expect(response, httpResponse);
  });

  test('Should throw ForbiddenError if FetchSecureCacheStorage throws', () async {
    mockTokenError();

    final future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.forbidden));
  });

  test('Should rethrow if decorate throws', () async {
    mockHttpResponseError(HttpError.badRequest);

    final future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.badRequest));
  });
}
