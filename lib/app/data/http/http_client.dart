import 'package:flutter/foundation.dart';

abstract class HttpClient {
  Future<Map> request({
    @required Uri url,
    @required String method,
    Map body,
  });
}
