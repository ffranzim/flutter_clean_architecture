import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

Authetication makeRemoteAuthentication() {
  return RemoteAuthetication(
    httpClient: makeHttpAdapter<Map>(),
    url: makeApiUrl('login'),
  );
}
