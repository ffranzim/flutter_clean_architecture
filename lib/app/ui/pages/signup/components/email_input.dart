import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/helpers.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.strings.email,
        //TODO não consegui fazer com o ThemeData
        icon: Icon(
          Icons.email,
          color: Theme.of(context).primaryColor,
        ),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
