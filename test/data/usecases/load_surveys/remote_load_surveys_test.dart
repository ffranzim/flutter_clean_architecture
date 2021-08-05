import 'package:clean_architecture/app/data/http/http.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class RemoteLoadSurveys {
  final Uri url;
  final HttpClient httpClient;

  RemoteLoadSurveys({@required this.url, @required this.httpClient});

  Future<void> load() async {
    await httpClient.request(url: url, method: 'get');

  }
}

class HttpClientSpy extends Mock implements HttpClient {
}

void main() {
  test('Should call HttpClient with correct values', () async {
    final url = Uri.parse(faker.internet.httpUrl());
    final httpClient = HttpClientSpy();
    final sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });
}
