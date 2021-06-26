import 'dart:convert';

import 'package:clean_architecture/app/data/http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';

class ClientSpy extends Mock implements Client {}

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  final headers = {
    'content-type': 'application/json',
    'accept': 'application/json',
  };

  @override
  Future<Map> request(
      {@required Uri url, @required String method, Map body}) async {
    final jsonBody = body != null ? jsonEncode(body) : null;
    final response = await client.post(url, headers: headers, body: jsonBody);

    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } else {
      return null;
    }
  }
}

void main() {
  Client client;
  HttpAdapter sut;
  Uri url;
  Map body;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = Uri.parse(faker.internet.httpUrl());
    body = {'any_key': 'any_value'};
  });

  group('post', () {
    PostExpectation mockRequest() => when(
        client.post(url, body: anyNamed('body'), headers: anyNamed('headers')));

    void mockResponse(int statusCode,
        {String body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    setUp(() {
      mockResponse(200);
    });

    test('Should call post with correct values', () async {
      await sut.request(
        url: url,
        method: 'post',
        body: body,
      );

      verify(
        client.post(
          url,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          },
          body: json.encode(body),
        ),
      );
    });

    test('Should call post without body', () async {
      await sut.request(
        url: url,
        method: 'post',
      );

      verify(
        client.post(
          url,
          headers: anyNamed('headers'),
        ),
      );
    });

    test('Should return data if post returns 200', () async {
      final response = await sut.request(url: url, method: 'post');

      expect(response, {'any_key': 'any_value'});
    });

    test('Should return null if post returns 200 with no data', () async {
      mockResponse(200, body: '');

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Should return null if post returns 204', () async {
      mockResponse(204, body: '');

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Should return null if post returns 204 with data', () async {
      mockResponse(204);

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });
  });
}
