import 'package:clean_architecture/app/ui/pages/pages.dart';
import 'package:flutter/material.dart';

import '../../factories.dart';

Widget makeSignUpPage() {
  return SignUpPage(presenter: makeGetxSignUpPresenter());
}
