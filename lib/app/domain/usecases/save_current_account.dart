import 'package:flutter/cupertino.dart';

import '../entities/account_entity.dart';

abstract class SaveCurrentAccount {
  Future<void> saveSecure({@required AccountEntity account});
}
