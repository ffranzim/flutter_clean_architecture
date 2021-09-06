import 'package:localstorage/localstorage.dart';

import '../../../infra/cache/cache.dart';

LocalStorageAdapter makeLocalStorageAdapter() =>
   LocalStorageAdapter(localStorage: LocalStorage('clean_architecture_app'));
