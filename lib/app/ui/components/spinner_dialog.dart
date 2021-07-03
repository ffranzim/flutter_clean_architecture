import 'package:flutter/material.dart';

void showLoading({@required BuildContext context}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return SimpleDialog(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(
                height: 12,
              ),
              Text('Aguarde ...', textAlign: TextAlign.center)
            ],
          ),
        ],
      );
    },
  );
}

void hideLoading({@required BuildContext context}) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}