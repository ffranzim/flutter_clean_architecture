import 'package:flutter/foundation.dart';

import '../entities/account_entity.dart';

abstract class LoadCurrentAccount {
  Future<AccountEntity> load({@required String key});
}
