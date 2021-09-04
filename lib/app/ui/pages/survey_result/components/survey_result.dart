import 'package:flutter/material.dart';

import '../survey_result_viewmodel.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;

  const SurveyResult({this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.answers.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            decoration: BoxDecoration(color: Theme.of(context).disabledColor.withAlpha(90)),
            padding: const EdgeInsets.only(top: 16, bottom: 8, right: 8, left: 8),
            child: Text(
              viewModel.question,
              textAlign: TextAlign.center,
            ),
          );
        }
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (viewModel.answers[index -1].image != null) Image.network(
                    viewModel.answers[index -1].image,
                    width: 36.0,
                  ) else const SizedBox(height: 1,),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(viewModel.answers[index - 1].answer,
                        style: const TextStyle(fontSize: 16)),
                  )),
                  Text(viewModel.answers[index - 1].percent,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark)),
                  if (viewModel.answers[index - 1].isCurrentAnswer) ActiveIcon() else DisableIcon()
                ],
              ),
            ),
            const Divider(
              height: 1,
            ),
          ],
        );
      },
    );
  }
}

class ActiveIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Icon(Icons.check_circle, color: Theme.of(context).highlightColor),
    );
  }
}

class DisableIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Icon(Icons.check_circle, color: Theme.of(context).disabledColor),
    );
  }
}
