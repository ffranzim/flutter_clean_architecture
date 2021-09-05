import 'package:flutter/material.dart';

class SurveyHeader extends StatelessWidget {
  final String question;

  const SurveyHeader({Key key, this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).disabledColor.withAlpha(90)),
      padding: const EdgeInsets.only(top: 16, bottom: 8, right: 8, left: 8),
      child: Text(
        question,
        textAlign: TextAlign.center,
      ),
    );
  }
}
