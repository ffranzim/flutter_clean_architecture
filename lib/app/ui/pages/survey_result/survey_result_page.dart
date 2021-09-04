import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import 'components/components.dart';
import 'survey_result_presenter.dart';
import 'survey_result_viewmodel.dart';

class SurveyResultPage extends StatelessWidget {
  final SurveyResultPresenter presenter;

  const SurveyResultPage({Key key, @required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(R.strings.surveys),
        ),
        body: Builder(
          builder: (context) {
            presenter.isLoadingStream.listen((isLoading) {
              if (isLoading == true) {
                showLoading(context: context);
              } else {
                hideLoading(context: context);
              }
            });

            presenter.loadData();

            return StreamBuilder<SurveyResultViewModel>(
              stream: presenter.surveyResultStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  final String message = snapshot.error.toString();
                  return ReloadScreen(message: message, reload: presenter.loadData);
                }

                // if (!snapshot.hasData || snapshot.data.isEmpty) {
                //   final String message = UIError.unexpected.description;
                //   return ReloadScreen(message: message, reload: presenter.loadData);
                // }

                if (snapshot.hasData) {
                  return SurveyResult(viewModel: snapshot.data);
                }

                // presenter.loadData();
                return const SizedBox(height: 0);
              },
            );
          },
        ));
  }
}
