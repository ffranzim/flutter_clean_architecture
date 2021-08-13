import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/surveys/surveys_presenter.dart';

import '../../usecases/load_surveys_factory.dart';

SurveysPresenter makeGetxSurveysPresenter() {
  return GetxSurveysPresenter(loadSurveys: makeRemoteLoadSurveys());
}
