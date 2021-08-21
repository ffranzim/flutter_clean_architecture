import 'package:flutter/foundation.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/domain_error.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteAuthetication implements Authetication {
  final HttpClient httpClient;
  final Uri url;

  RemoteAuthetication({@required this.httpClient, @required this.url});

  @override
  Future<AccountEntity> auth({@required AuthenticationParams params}) async {
    try {
      final httpResponse = await httpClient.request(
          url: url,
          method: 'post',
          body: RemoteAuthenticationParams.fromDomain(params).toJson());
      // ignore: argument_type_not_assignable
      return RemoteAccountModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      error == HttpError.unauthorized
          ? throw DomainError.invalidCredentials
          : throw DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    @required this.email,
    @required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams entity) =>
      RemoteAuthenticationParams(email: entity.email, password: entity.secret);

  Map toJson() => {'email': email, 'password': password};
}
