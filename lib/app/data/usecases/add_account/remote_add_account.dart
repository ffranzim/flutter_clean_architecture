import 'package:clean_architecture/app/data/models/models.dart';
import 'package:clean_architecture/app/domain/helpers/helpers.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteAddAccount implements AddAccount {
  final HttpClient httpClient;
  final Uri url;

  RemoteAddAccount({@required this.httpClient, @required this.url});

  @override
  Future<AccountEntity> add({@required AddAccountParams params}) async {
    try {
      final httpResponse = await httpClient.request(
          url: url,
          method: 'post',
          body: RemoteAddAccountParams.fromDomain(params).toJson());
          // ignore: argument_type_not_assignable
          return RemoteAccountModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      error == HttpError.forbidden
          ? throw DomainError.emailInUse
          : throw DomainError.unexpected;
    }
  }
}

class RemoteAddAccountParams{
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

  factory RemoteAddAccountParams.fromDomain(AddAccountParams entity) =>
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
