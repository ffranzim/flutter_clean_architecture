import 'package:clean_architecture/app/ui/pages/pages.dart';
import 'package:flutter/material.dart';

import '../survey_result_viewmodel.dart';
import 'components.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;

  const SurveyResult({this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.answers.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return SurveyHeader(question: viewModel.question);
        }
        return SurveyAnwser(viewModel: viewModel.answers[index -1]);
      },
    );
  }
}

