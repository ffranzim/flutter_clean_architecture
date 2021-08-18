import 'package:clean_architecture/app/data/cache/cache.dart';
import 'package:clean_architecture/app/data/http/http.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class AuthorizeHttpClientDecorator<ResponseType> implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  //? convenção de decorator
  final HttpClient<ResponseType> decoratee;

  AuthorizeHttpClientDecorator({
    @required this.fetchSecureCacheStorage,
    this.decoratee,
  });

  @override
  Future<ResponseType> request({
    @required Uri url,
    @required String method,
    Map body,
    Map headers,
  }) async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure(key: 'token');
      final authorizeHeaders = headers ?? {}
        ..addAll({'x-access-token': token});
      final result = await decoratee.request(
        url: url,
        method: method,
        body: body,
        headers: authorizeHeaders,
      );

      return result;
    } catch (error) {
      throw HttpError.forbidden;
    }
  }
}

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

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

  void mockHttpResponse() {
    httpResponse = faker.randomGenerator.string(50);
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => httpResponse);
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

    await sut.request(
        url: url,
        method: method,
        body: body,
        headers: {'any_header': 'any_value'});
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

  test('Should throw ForbiddenError if FetchSecureCacheStorage', () async {
    mockTokenError();

    final future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.forbidden));
  });
}
