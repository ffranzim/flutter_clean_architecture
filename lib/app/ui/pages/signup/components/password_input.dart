import 'package:clean_architecture/app/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helpers/helpers.dart';

class PasswordInput extends StatelessWidget {
  final presenter = Get.find<SignUpPresenter>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UIError>(
      stream: presenter.passwordErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: R.strings.password,
            //TODO não consegui fazer com o ThemeData
            icon: Icon(
              Icons.lock,
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
            // errorText: snapshot.hasData ? snapshot.data.description : null,
          ),
          obscureText: true,
          onChanged: (password) {
            presenter.validatePassword(password: password);
          }
        );
      },
    );
  }
}