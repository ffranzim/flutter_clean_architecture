import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_presenter.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<String>(
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
              errorText: snapshot.data?.isEmpty == true ? null : snapshot.data),
          obscureText: true,
          onChanged: (password) => presenter.validatePassword(password: password),
          // keyboardType: TextInputType.visiblePassword,
        );
      },
    );
  }
}
