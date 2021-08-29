import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localstorage/localstorage.dart';

import '../../../infra/cache/cache.dart';

LocalStorageAdapter makeLocalStorageAdapter() =>
   LocalStorageAdapter(localStorage: LocalStorage('clean_architecture_app'));
