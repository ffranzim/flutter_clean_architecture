import 'package:flutter/foundation.dart';

import '../../../data/cache/cache.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorageSpy;

  LocalLoadCurrentAccount({@required this.fetchSecureCacheStorageSpy});

  @override
  Future<AccountEntity> load({@required String key}) async {
    try {
      final token = await fetchSecureCacheStorageSpy.fetchSecure(key: key);
      return AccountEntity(token: token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}