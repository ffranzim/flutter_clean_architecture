import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../infra/cache/local_storage_adapter.dart';

LocalStorageAdapater makeLocalStorageAdapter() {
  final secureStorage = FlutterSecureStorage();
  return LocalStorageAdapater(secureStorage: secureStorage);

}