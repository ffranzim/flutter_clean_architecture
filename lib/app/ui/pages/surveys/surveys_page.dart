import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            enlargeCenterPage: true,
                            aspectRatio: 1,
                            // enableInfiniteScroll: false,
                          ),
                          items: snapshot.data
                              .map((viewModel) => SurveyItem(surveyViewModel: viewModel))
                              .toList(),
                        ),
                      ),
                      // ElevatedButton(onPressed: presenter.loadData, child: Text(R.strings.reload))
                    ],
                  );
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
