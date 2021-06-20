import '../entities/entities.dart';

abstract class Authetication {
  Future<AccountEntity> auth({required String email, required String password});
}
