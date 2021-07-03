import 'package:flutter/material.dart';

class EmailInput extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: presenter.emailErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
                labelText: 'Email',
                //TODO não consegui fazer com o ThemeData
                icon: Icon(
                  Icons.email,
                  color: Theme.of(context).primaryColor,
                ),
                errorText: snapshot.data?.isEmpty == true
                    ? null
                    : snapshot.data),
            keyboardType: TextInputType.emailAddress,
            onChanged: presenter.validateEmail,
          );
        });
  }
}