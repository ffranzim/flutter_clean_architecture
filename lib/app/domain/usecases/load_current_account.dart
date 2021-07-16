import 'package:flutter/cupertino.dart';

import '../entities/account_entity.dart';

abstract class LoadCurrentAccount {
  Future<AccountEntity> load();
}
