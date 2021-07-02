import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';

import '../../components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;
  final Logger _log = Logger();

  LoginPage({@required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoginHeader(),
          const Headline1(text: 'login'),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
                child: Column(
              children: [
                StreamBuilder<String>(
                    stream: presenter.emailErrorStream,
                    builder: (context, snapshot) {
                      return TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Email',
                            //TODO não consegui fazer com o ThemeData
                            icon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            ),
                            errorText: snapshot.data?.isEmpty == true
                                ? null
                                : snapshot.data),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: presenter.validateEmail,
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 32.0),
                  child: StreamBuilder<String>(
                      stream: presenter.passwordErrorStream,
                      builder: (context, snapshot) {
                        return TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Senha',
                              //TODO não consegui fazer com o ThemeData
                              icon: Icon(
                                Icons.lock,
                                color: Theme.of(context).primaryColor,
                              ),
                              errorText: snapshot.data?.isEmpty == true
                                  ? null
                                  : snapshot.data),
                          obscureText: true,
                          onChanged: presenter.validatePassword,
                          // keyboardType: TextInputType.visiblePassword,
                        );
                      }),
                ),
                StreamBuilder<bool>(
                  stream: presenter.isFormValidController,
                  builder: (context, snapshot) {
                    return ElevatedButton(
                      onPressed: snapshot.data == true ? presenter.auth : null,
                      child: Text('Entrar'.toUpperCase()),
                    );
                  }
                ),
                TextButton.icon(
                  onPressed: () => _log.i('TextButton'),
                  icon: const Icon(Icons.person),
                  label: const Text('Criar Conta'),
                )
              ],
            )),
          )
        ],
      )),
    );
  }
}
