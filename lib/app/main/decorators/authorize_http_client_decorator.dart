import 'package:flutter/foundation.dart';

import '../../data/cache/cache.dart';
import '../../data/http/http.dart';

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
    } on HttpError {
      rethrow;
    } catch (error) {
      throw HttpError.forbidden;
    }
  }
}