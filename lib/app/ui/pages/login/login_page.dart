import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../ui/components/spinner_dialog.dart';
import '../../components/components.dart';
import './components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  const LoginPage({@required this.presenter});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Logger _log = Logger();

  @override
  void dispose() {
    super.dispose();
    widget.presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        widget.presenter.isLoadingController.listen((isLoading) {
          if (isLoading) {
            showLoading(context: context);
          } else {
            hideLoading(context: context);
          }
        });

        widget.presenter.mainErrorController.listen((error) {
          if (error.isNotEmpty) {
            showErrorMessage(context: context, msg: error);
          }
        });

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LoginHeader(),
              const Headline1(text: 'login'),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Provider(
                  create: (_) => widget.presenter,
                  child: Form(
                    child: Column(
                      children: [
                        EmailInput(),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 8.0, bottom: 32.0),
                          child: StreamBuilder<String>(
                            stream: widget.presenter.passwordErrorStream,
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
                                onChanged: widget.presenter.validatePassword,
                                // keyboardType: TextInputType.visiblePassword,
                              );
                            },
                          ),
                        ),
                        StreamBuilder<bool>(
                            stream: widget.presenter.isFormValidController,
                            builder: (context, snapshot) {
                              return ElevatedButton(
                                onPressed: snapshot.data == true
                                    ? widget.presenter.auth
                                    : null,
                                child: Text('Entrar'.toUpperCase()),
                              );
                            }),
                        TextButton.icon(
                          onPressed: () => _log.i('TextButton'),
                          icon: const Icon(Icons.person),
                          label: const Text('Criar Conta'),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
