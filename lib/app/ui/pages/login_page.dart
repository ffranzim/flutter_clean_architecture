import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';

import '../components/components.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key key}) : super(key: key);
  final Logger _log = Logger();

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
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    //TODO não consegui fazer com o ThemeData
                    icon: Icon(
                      Icons.email,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 32.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      //TODO não consegui fazer com o ThemeData
                      icon: Icon(
                        Icons.lock,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    obscureText: true,
                    // keyboardType: TextInputType.visiblePassword,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _log.i('ElevatedButton'),
                  child: Text('Entrar'.toUpperCase()),
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
