import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240.0,
      margin: const EdgeInsets.only(bottom: 32.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Theme
                .of(context)
                .primaryColorLight,
            Theme
                .of(context)
                .primaryColorDark
          ],
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 4.0,
          ),
        ],
        borderRadius:
        const BorderRadius.only(bottomLeft: Radius.circular(80.0)),
      ),
      child: const Image(image: AssetImage('lib/app/ui/assets/logo.png')),
    );
  }
}