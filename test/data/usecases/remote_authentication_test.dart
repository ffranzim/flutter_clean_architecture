import 'package:clean_architecture/app/domain/usecases/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

class RemoteAuthetication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthetication({required this.httpClient, required this.url});

  Future<void> auth(AuthenticationParams params) async {
    final body = {'email': params.email, 'password': params.secret};
     await httpClient.request(url: url, method: 'post', body: body);
  }
}

abstract class HttpClient {
  Future<void>? request(
      {required String url, required String method, Map body});
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthetication sut;
  late HttpClient httpClient;
  late String url;

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
}
