import 'package:clean_architecture/app/ui/pages/pages.dart';
import 'package:clean_architecture/app/ui/pages/surveys/surveys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  testWidgets('Should call Load Surveys on page load', (WidgetTester tester) async {
    final presenter = SurveysPresenterSpy();
    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [GetPage(name: '/surveys', page: () => SurveysPage(presenter: presenter))],
    );

    await tester.pumpWidget(surveysPage);

    verify(presenter.loadData()).called(1);
  });
}
