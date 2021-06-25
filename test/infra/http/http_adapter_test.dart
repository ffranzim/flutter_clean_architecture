import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';

class ClientSpy extends Mock implements Client {}

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  final headers = {
    'content-type': 'application/json',
    'accept': 'application/json',
  };

  Future<Map?> request({
    required Uri url,
    required String method,
    Map? body,
  }) async {
    final jsonBody = body != null ? jsonEncode(body) : null;

    try {
      await client.post(url, headers: headers, body: jsonBody);
    } on Exception catch (e) {
      print(e);
    } finally {
      return Future.value({});
    }
  }
}

void main() {
  late Client client;
  late HttpAdapter sut;
  late Uri url;
  late Map body;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = Uri.parse(faker.internet.httpUrl());
    body = {'any_key': 'any_value'};
  });

  group('post', () {
    test('Should call post with correct values', () async {
      await sut.request(
        url: url,
        method: 'post',
        body: body,
      );

      verify(
        () => client.post(
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
        () => client.post(
          url,
          headers: any(named: 'headers'),
        ),
      );
    });
  });
}
