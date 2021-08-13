import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../../data/http/http.dart';

class HttpAdapterListMap implements HttpClient<List<Map>> {
  final Client client;

  HttpAdapterListMap(this.client);

  final headers = {
    'content-type': 'application/json',
    'accept': 'application/json',
  };

  String jsonBody(Map body) => body != null ? jsonEncode(body) : null;

  @override
  Future<List<Map>> request({@required Uri url, @required String method, Map body}) async {
    var response = Response('', 500);

    try {
      if (method == 'post') {
        response = await client.post(url, headers: headers, body: jsonBody(body));
      } else if (method == 'get') {
        response = await client.get(url, headers: headers);
      }
    } catch (error) {
      throw HttpError.serverError;
    }

    return _handleResponse(response);
  }

  T _handleResponse<T>(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body) as T;
    } else if (response.statusCode == 204) {
      return null;
    } else if (response.statusCode == 400) {
      throw HttpError.badRequest;
    } else if (response.statusCode == 401) {
      throw HttpError.unauthorized;
    } else if (response.statusCode == 403) {
      throw HttpError.forbidden;
    } else if (response.statusCode == 404) {
      throw HttpError.notFound;
    } else {
      throw HttpError.serverError;
    }
  }
}
