import 'package:flutter/material.dart';

import '../survey_viewmodel.dart';

class SurveyItem extends StatelessWidget {
  final SurveyViewModel surveyViewModel;

  const SurveyItem({@required this.surveyViewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: surveyViewModel.didAnswer ? Theme.of(context).secondaryHeaderColor : Theme.of(context).primaryColorDark,
            boxShadow: const [BoxShadow(offset: Offset(0, 1), blurRadius: 2)],
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              surveyViewModel.date,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              surveyViewModel.question,
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
