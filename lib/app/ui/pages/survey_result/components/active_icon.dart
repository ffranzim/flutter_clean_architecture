import 'package:flutter/material.dart';

class DisableIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Icon(Icons.check_circle, color: Theme.of(context).disabledColor),
    );
  }
}
