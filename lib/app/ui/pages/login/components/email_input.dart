import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/helpers.dart';
import '../login_presenter.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final presenter = Provider.of<LoginPresenter>(context);
    // final presenter = Provider.of<GetxLoginPresenter>(context);

    final presenter = Get.find<LoginPresenter>();

    return StreamBuilder<UIError>(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
              labelText: R.strings.email,
              //TODO não consegui fazer com o ThemeData
              icon: Icon(
                Icons.email,
                color: Theme.of(context).primaryColor,
              ),
              errorText: snapshot.hasData ? snapshot.data.description : null),
          keyboardType: TextInputType.emailAddress,
          onChanged: (email) => presenter.validateEmail(email: email),
        );
      },
    );
  }
}
