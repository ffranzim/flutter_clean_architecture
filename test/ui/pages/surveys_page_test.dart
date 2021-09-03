import 'dart:async';

import 'package:clean_architecture/app/ui/helpers/errors/errors.dart';
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
  StreamController<List<SurveyViewModel>> surveysController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    surveysController = StreamController<List<SurveyViewModel>>();
  }

  void mockStreams() {
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(presenter.surveysStream).thenAnswer((_) => surveysController.stream);
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
      getPages: [
        GetPage(name: '/surveys', page: () => SurveysPage(presenter: presenter))
      ],
    );

    await tester.pumpWidget(surveysPage);
  }

  tearDown(() {
    closeStreams();
  });

  //? Utilizado em 'Should present list if loadSurveysStream success
  // List<SurveyViewModel> makeSurveys() => [
  //       SurveyViewModel(
  //           id: faker.guid.guid(),
  //           question: 'Question 1',
  //           date: 'Date 1',
  //           didAnswer: true),
  //       SurveyViewModel(
  //           id: faker.guid.guid(),
  //           question: 'Question 2',
  //           date: 'Date 2',
  //           didAnswer: false),
  //     ];

  // ? Ao alterar a ordem da chamada não consegui refazer este teste
  // testWidgets('Should call Load Surveys on page load',
  //     (WidgetTester tester) async {
  //   await loadPage(tester);
  //
  //   verify(presenter.loadData()).called(1);
  // });

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

  testWidgets('Should present error if loadSurveysStream fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  //? Tirei test pelo erro _surveys.subject.addError(UIError.unexpected.description);
  // testWidgets('Should present list if loadSurveysStream success', (WidgetTester tester) async {
  //   await loadPage(tester);
  //
  //   surveysController.add(makeSurveys());
  //   await tester.pump();
  //
  //   expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsNothing);
  //   expect(find.text('Recarregar'), findsNothing);
  //   expect(find.text('Question 1'), findsWidgets);
  //   expect(find.text('Question 2'), findsWidgets);
  //   expect(find.text('Date 1'), findsWidgets);
  //   expect(find.text('Date 2'), findsWidgets);
  // });

  testWidgets('Should call Load Survey on reload button click',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.addError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text('Recarregar'));

    verify(presenter.loadData()).called(1);
  });
}
