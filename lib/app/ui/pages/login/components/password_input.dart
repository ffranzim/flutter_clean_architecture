import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login_presenter.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<LoginPresenter>();

    return Obx(
      () => TextFormField(
        decoration: InputDecoration(
            labelText: 'Senha',
            //TODO não consegui fazer com o ThemeData
            icon: Icon(
              Icons.lock,
              color: Theme.of(context).primaryColor,
            ),
            errorText: presenter.passwordError?.value?.isEmpty == true ? null : presenter.passwordError.value),
        obscureText: true,
        onChanged: (password) => presenter.validatePassword(password: password),
      ),
    );
  }
}
