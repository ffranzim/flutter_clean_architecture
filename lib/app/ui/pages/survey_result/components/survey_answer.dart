import 'package:flutter/material.dart';

import '../survey_answer_viewmodel.dart';
import 'components.dart';

class SurveyAnwser extends StatelessWidget {
  const SurveyAnwser({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final SurveyAnswerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildItems(context),
          ),
        ),
        const Divider(
          height: 1,
        ),
      ],
    );
  }

  List<Widget> _buildItems(BuildContext context) {
    final List<Widget> children = [
      Expanded(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(viewModel.answer, style: const TextStyle(fontSize: 16)),
      )),
      Text(viewModel.percent,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorDark)),
      if (viewModel.isCurrentAnswer) ActiveIcon() else DisableIcon()
    ];

    if (viewModel.image != null) {
      children.insert(
        0,
        Image.network(
          viewModel.image,
          width: 36.0,
        ),
      );
    }

    return children;
  }
}
