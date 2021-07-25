import 'package:clean_architecture/app/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/helpers.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<SignUpPresenter>();

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
            // errorText: snapshot.hasData ? snapshot.data.description : null,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (email) => presenter.validateEmail(email: email),
        );
      },
    );
  }
}
