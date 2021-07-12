import 'package:clean_architecture/app/presentation/presenters/getx_login_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_presenter.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final presenter = Provider.of<LoginPresenter>(context);
    final presenter = Provider.of<GetxLoginPresenter>(context);
    return StreamBuilder<bool>(
      stream: presenter.isFormValidStream,
      builder: (context, snapshot) {
        return ElevatedButton(
          onPressed: snapshot.data == true ? presenter.auth : null,
          child: Text('Entrar'.toUpperCase()),
        );
      },
    );
  }
}
