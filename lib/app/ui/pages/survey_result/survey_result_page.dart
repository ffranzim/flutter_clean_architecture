import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import 'survey_result_presenter.dart';

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

            return ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    decoration: BoxDecoration(color: Theme.of(context).disabledColor.withAlpha(90)),
                    padding: const EdgeInsets.only(top: 16, bottom: 8, right: 8, left: 8),
                    child: const Text(
                      'Qual é o seu framework favorito?',
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
                          Image.network(
                            'https://fordevs.herokuapp.com/static/img/logo-angular.png',
                            width: 36.0,
                          ),
                          const Expanded(
                              child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('Angular', style: TextStyle(fontSize: 16)),
                          )),
                          Text('100%',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColorDark)),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child:
                                Icon(Icons.check_circle, color: Theme.of(context).highlightColor),
                          )
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
          },
        ));
  }
}
