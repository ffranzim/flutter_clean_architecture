import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/login/login_presenter.dart';
import '../../factories.dart';

LoginPresenter makeStreamLoginPresenter() {
  return StreamLoginPresenter(
      validation: makeLoginValidation(),
      authentication: makeRemoteAuthentication());
}

LoginPresenter makeGetxLoginPresenter() {
  return GetxLoginPresenter(
      validation: makeLoginValidation(),
      authentication: makeRemoteAuthentication(), saveCurrentAccount: makeLocalSaveCurrentAccount());
}
