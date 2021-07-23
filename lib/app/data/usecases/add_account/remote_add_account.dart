import 'package:clean_architecture/app/domain/helpers/helpers.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteAddAccount {
  //implements Authetication {
  final HttpClient httpClient;
  final Uri url;

  RemoteAddAccount({@required this.httpClient, @required this.url});

  @override
  Future<void> add({@required RemoteAddAccountParams params}) async {
    try {
      final httpResponse = await httpClient.request(
          url: url,
          method: 'post',
          body: RemoteAddAccountParams.fromDomain(params).toJson());
    } on HttpError catch (error) {
      // error == HttpError.unauthorized
      //     ? throw DomainError.invalidCredentials
      //     : throw DomainError.unexpected;
      throw DomainError.unexpected;
    }
  }
}

class RemoteAddAccountParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  RemoteAddAccountParams({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.passwordConfirmation,
  });

  factory RemoteAddAccountParams.fromDomain(RemoteAddAccountParams entity) =>
      RemoteAddAccountParams(
        name: entity.name,
        email: entity.email,
        password: entity.password,
        passwordConfirmation: entity.passwordConfirmation,
      );

  Map toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'passwordConfirmation': passwordConfirmation,
      };
}
