import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login_presenter.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final presenter = Provider.of<LoginPresenter>(context);
    // final presenter = Provider.of<GetxLoginPresenter>(context);
    final presenter = Get.find<LoginPresenter>();

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
