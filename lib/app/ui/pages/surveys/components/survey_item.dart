import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../survey_viewmodel.dart';
import '../surveys_presenter.dart';

class SurveyItem extends StatelessWidget {
  final SurveyViewModel surveyViewModel;


  const SurveyItem({@required this.surveyViewModel});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SurveysPresenter>(context);

    return GestureDetector(
      onTap: () {
        presenter.goToSurveyResult(surveyId: surveyViewModel.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              color: surveyViewModel.didAnswer ? Theme.of(context).primaryColorDark : Theme.of(context).secondaryHeaderColor,
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
      ),
    );
  }
}
