import 'package:flutter/material.dart';
import '../../../helpers/helpers.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.strings.name,
        //TODO não consegui fazer com o ThemeData
        icon: Icon(
          Icons.person,
          color: Theme.of(context).primaryColor,
        ),
      ),
      keyboardType: TextInputType.name,
    );
  }
}
