import 'package:flutter/foundation.dart';

import '../../data/cache/cache.dart';
import '../../data/http/http.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  //? convenção de decorator
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator({
    @required this.fetchSecureCacheStorage,
    this.decoratee,
  });

  @override
  Future<dynamic> request({
    @required Uri url,
    @required String method,
    Map body,
    Map headers,
  }) async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure(key: 'token');
      final authorizeHeaders = headers ?? {}
        ..addAll({'x-access-token': token});
        // ..addAll({'x-access-token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVmODg4ZWM3MzI0NmUxMDAxNzEzMGViZCIsImlhdCI6MTYyOTMzOTM1MH0.PgzoBa8gk8gAKI3ZPfGF2uxG4WzF42ApwxFwzV2ePJU'});
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