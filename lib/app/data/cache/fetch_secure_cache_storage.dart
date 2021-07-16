import 'package:flutter/foundation.dart';

abstract class FetchSecureCacheStorage {
  Future<String> fetchSecure({@required String key});
}
