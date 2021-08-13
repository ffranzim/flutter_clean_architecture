import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

LoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl('signup'),
  );
}
// TODO transformar numa coisa só
// LoadSurveys makeRemoteLoadSurveys() {
//   return RemoteLoadSurveys(
//     httpClient: makeHttpAdapterListMap(),
//     url: makeApiUrl('signup'),
//   );
// }
