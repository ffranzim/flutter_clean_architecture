import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../ui/pages/pages.dart';
import 'surveys_presenter_factory.dart';

Widget makeSurveysPage() {
  return SurveysPage(presenter: makeGetxSurveysPresenter());
}
