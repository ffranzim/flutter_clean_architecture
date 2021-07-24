import 'package:flutter/material.dart';
import '../../../helpers/helpers.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.strings.password,
        //TODO não consegui fazer com o ThemeData
        icon: Icon(
          Icons.lock,
          color: Theme.of(context).primaryColor,
        ),
      ),
      obscureText: true,
    );
  }
}
