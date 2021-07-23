import 'package:clean_architecture/app/data/http/http.dart';
import 'package:clean_architecture/app/data/usecases/usecases.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAddAccount sut;
  HttpClient httpClient;
  Uri url;
  RemoteAddAccountParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = Uri.parse(faker.internet.httpsUrl());
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
    params = RemoteAddAccountParams(
      name: faker.person.name(),
      email: faker.internet.email(),
      password: faker.internet.password(),
      passwordConfirmation: faker.internet.password(),
    );
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
}
