
import '../../decorators/decorators.dart';
import '../../factories/factories.dart';

AuthorizeHttpClientDecorator makeAuthorizeHttpClientDecorator() {
  return AuthorizeHttpClientDecorator(
    decoratee: makeHttpAdapter(),
    fetchSecureCacheStorage: makeSecureStorageAdapter(),
  );
}
