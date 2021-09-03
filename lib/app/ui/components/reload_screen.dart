import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

class ReloadScreen extends StatelessWidget {
  final String message;
  final Future<void> Function() reload;

  const ReloadScreen({ @required this.message, @required this.reload });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(message, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
        ),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: reload, child: Text(R.strings.reload))
      ],
    );
  }
}