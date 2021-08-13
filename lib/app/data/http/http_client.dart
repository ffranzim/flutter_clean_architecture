import 'package:flutter/foundation.dart';

abstract class HttpClient<ResponseType> {
  Future<ResponseType> request ({
    @required Uri url,
    @required String method,
    Map body,
  });
}
