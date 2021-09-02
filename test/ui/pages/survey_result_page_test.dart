import 'dart:async';

import 'package:clean_architecture/app/ui/pages/pages.dart';
import 'package:clean_architecture/app/ui/pages/survey_result/survey_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}


void main() {
  SurveyResultPresenter presenter;


  void initStreams() {
  }

  void mockStreams() {
  }

  void closeStreams() {
  }

  setUp(() {
    presenter = SurveyResultPresenterSpy();
  });

  Future<void> loadPage(WidgetTester tester) async {
    initStreams();
    mockStreams();

    final surveysPage = GetMaterialApp(
      initialRoute: '/survey_result/any_survey_id',
      getPages: [
        GetPage(name: '/survey_result/:survey_id', page: () => SurveyResultPage(presenter: presenter))
      ],
    );


      mockNetworkImagesFor(() async => tester.pumpWidget(surveysPage));

    // await tester.pumpWidget(surveysPage);
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should call LoadSurveyResult on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(presenter.loadData()).called(1);
  });


}
