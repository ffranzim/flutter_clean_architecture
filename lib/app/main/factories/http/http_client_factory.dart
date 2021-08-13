import 'package:http/http.dart';

import '../../../data/http/http.dart';
import '../../../infra/http/http.dart';

HttpClient<ResponseType> makeHttpAdapter<ResponseType>() {
  final client = Client();
  return HttpAdapter<ResponseType>(client);
}
