import 'package:flutter/foundation.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/domain_error.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorageSpy;

  LocalSaveCurrentAccount({@required this.saveSecureCacheStorageSpy});

  @override
  Future<void> saveSecure({@required AccountEntity account}) async {
    try {
      await saveSecureCacheStorageSpy.saveSecure(key: 'token', value: account.token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}