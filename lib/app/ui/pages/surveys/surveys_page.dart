import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import 'components/components.dart';
import 'survey_viewmodel.dart';
import 'surveys_presenter.dart';

// class SurveysPage extends GetView<GetxSurveysPresenter> {
class SurveysPage extends StatelessWidget {
  final SurveysPresenter presenter;

  const SurveysPage({@required this.presenter});

  @override
  Widget build(BuildContext context) {
    Get.put(presenter);
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      //? Tive que colocar nos testes, mas não precisou mais. Deixei por precaucao
      // body: SingleChildScrollView(
      //   child: Builder(
      body: Builder(
        builder: (context) {
          presenter.isLoadingStream.listen((isLoading) {
            if (isLoading == true) {
              showLoading(context: context);
            } else {
              hideLoading(context: context);
            }
          });

          presenter.navigateToStream.listen((page) {
            if (page?.isNotEmpty == true) {
              //! offAllNamed remove rodas as rotas e inclui uma nova
              Get.toNamed(page);
            }
          });

          return StreamBuilder<List<SurveyViewModel>>(
              stream: presenter.surveysStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  final String message = snapshot.error.toString();
                  return ReloadScreen(message: message, reload: presenter.loadData);
                }

                if (!snapshot.hasData || snapshot.data.isEmpty) {
                  final String message = UIError.unexpected.description;
                  return ReloadScreen(message: message, reload: presenter.loadData);
                }

                if (snapshot.hasData) {
                  return Provider(
                      create: (_) => presenter,
                      child: SurveyItems(viewModels: snapshot.data));
                }

                presenter.loadData();
                return const SizedBox(height: 0);
              });
        },
      ),
      // ),
    );
  }
}