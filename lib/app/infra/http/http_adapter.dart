import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../../data/http/http.dart';

class HttpAdapter<ResponseType>  implements HttpClient<ResponseType>  {
  final Client client;

  HttpAdapter(this.client);

  String jsonBody(Map body) => body != null ? jsonEncode(body) : null;

  @override
  Future<ResponseType> request({@required Uri url, @required String method, Map body, Map headers}) async {

    //? Se o headers for nulo passa o map vazio
    //? .. pega o retorno da funçao, tipo pega o resultado do headers .(adiciona) .(retorna)
    final defaultHeaders = headers?.cast<String, String>() ?? {} ..addAll({
      'content-type': 'application/json',
      'accept': 'application/json',
    });


    var response = Response('', 500);

    try {
      if (method == 'post') {
        response = await client.post(url, headers: defaultHeaders, body: jsonBody(body));
      } else if (method == 'get') {
        response = await client.get(url, headers: defaultHeaders);
      }
    } catch (error) {
      throw HttpError.serverError;
    }

    return _handleResponse(response);
  }

  ResponseType _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body) as ResponseType;
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
