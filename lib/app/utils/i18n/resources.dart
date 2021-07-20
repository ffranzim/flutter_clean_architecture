import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';


import 'strings/strings.dart';

mixin R {
  static Translations strings = PtBr();

  static void load({@required Locale locale}) {
    switch(locale.toString()) {
      case 'en_US': strings = EnUs(); break;
      default: strings = PtBr(); break;
    }
  }
}
