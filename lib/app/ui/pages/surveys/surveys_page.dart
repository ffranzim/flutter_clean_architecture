import 'package:carousel_slider/carousel_slider.dart';
import 'package:clean_architecture/app/ui/pages/surveys/survey_viewmodel.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import 'components/components.dart';
import 'surveys_presenter.dart';

class SurveysPage extends StatelessWidget {
  final SurveysPresenter presenter;

  const SurveysPage({@required this.presenter});

  @override
  Widget build(BuildContext context) {
    presenter.loadData();

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

          return StreamBuilder<List<SurveyViewModel>>(
            stream: presenter.loadSurveysStream,
            builder: (context, snapshot) {
              if(snapshot.hasError)  {
                return Column(
                  children: [
                    Text(snapshot.error.toString()),
                    ElevatedButton(onPressed: () {}, child: Text(R.strings.reload))
                  ],
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: CarouselSlider(
                  options: CarouselOptions(enlargeCenterPage: true, aspectRatio: 1),
                  items: [
                    SurveyItem(),
                    SurveyItem(),
                    SurveyItem(),
                  ],
                ),
              );
            }
          );
        },
      ),
    );
  }
}
