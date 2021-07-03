import 'package:flutter/material.dart';

void showErrorMessage({@required BuildContext context, @required String msg}){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red[900],
    content: Text(msg, textAlign: TextAlign.center),
  ));
}