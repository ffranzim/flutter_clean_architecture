import 'dart:async';

import 'package:clean_architecture/app/ui/pages/pages.dart';
import 'package:clean_architecture/app/ui/pages/surveys/surveys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  SurveysPresenter presenter;

  StreamController<bool> isLoadingController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
  }

  void mockStreams() {
    when(presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
  }

  setUp(() {
    presenter = SurveysPresenterSpy();
  });

  Future<void> loadPage(WidgetTester tester) async {
    initStreams();
    mockStreams();
    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [GetPage(name: '/surveys', page: () => SurveysPage(presenter: presenter))],
    );

    await tester.pumpWidget(surveysPage);
  }

  tearDown((){
    closeStreams();
  });

  testWidgets('Should call Load Surveys on page load', (WidgetTester tester) async {
    await loadPage(tester);

    verify(presenter.loadData()).called(1);
  });

  testWidgets('Should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    //? true case
    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    //? false case
    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);

    //? true case
    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    //? null case
    isLoadingController.add(null);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);


  });
}
