import 'package:http/http.dart';

import '../../../data/http/http.dart';
import '../../../infra/http/http.dart';

HttpClient makeHttpAdapter() {
  final client = Client();
  return HttpAdapter(client);
}

// TODO transformar numa coisa só
// HttpClient<Map> makeHttpAdapter() {
//   final client = Client();
//   return HttpAdapter(client);
// }
// HttpClient<List<Map>> makeHttpAdapterListMap() {
//   final client = Client();
//   return HttpAdapterListMap(client);
// }
