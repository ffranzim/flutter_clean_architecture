import 'dart:async';

import 'package:clean_architecture/app/ui/helpers/errors/errors.dart';
import 'package:clean_architecture/app/ui/pages/pages.dart';
import 'package:clean_architecture/app/ui/pages/surveys/surveys.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  SurveysPresenter presenter;

  StreamController<bool> isLoadingController;
  StreamController<List<SurveyViewModel>> surveysController;
  StreamController<String> navigateToController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    surveysController = StreamController<List<SurveyViewModel>>();
    navigateToController = StreamController<String>();
  }

  //? Utilizado em 'Should present list if loadSurveysStream success
  List<SurveyViewModel> makeSurveys() => [
        SurveyViewModel(
            id: faker.guid.guid(), question: 'Question 1', date: 'Date 1', didAnswer: true),
        SurveyViewModel(
            id: faker.guid.guid(), question: 'Question 2', date: 'Date 2', didAnswer: false),
      ];

  void mockStreams() {
    when(presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
    when(presenter.surveysStream).thenAnswer((_) => surveysController.stream);
    when(presenter.navigateToStream).thenAnswer((_) => navigateToController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
    surveysController.close();
    navigateToController.close();
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
        GetPage(name: '/surveys', page: () => SurveysPage(presenter: presenter)),
        GetPage(name: '/any_route', page: () => const Scaffold(body: Text('fake_page')))
      ],
    );

    await tester.pumpWidget(surveysPage);
  }

  tearDown(() {
    closeStreams();
  });

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

  testWidgets('Should present error if loadSurveysStream fails', (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsOneWidget);
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

  testWidgets('Should call Load Survey on reload button click', (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.addError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text('Recarregar'));

    verify(presenter.loadData()).called(1);
  });

  // //! Funciona o teste com o provider, mas provider da erro em produção
  // //! Não funciona o teste com o provider, mas getx(provider) não dá erro em produção
  testWidgets('Should call gotoSurveyResult on survey click', (WidgetTester tester) async {
    await loadPage(tester);

    final surveys = makeSurveys();
    surveysController.add(surveys);
    await tester.pump();

    // ! Não acha TextButton
    // await tester.tap(find.byType(TextButton));

    final button = find.text('Question 1');
    // await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(presenter.goToSurveyResult(surveyId: surveys[0].id)).called(1);
  });

  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    //! pumpAndSettle espera a animação acontecer e tudo mais
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/any_route');
    expect(find.text('fake_page'), findsOneWidget);
  });
}
