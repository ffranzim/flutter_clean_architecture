import 'package:clean_architecture/app/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../ui/components/components.dart';
import 'factories/factories.dart';

void main() {
  // R.load(locale: const Locale('en', 'US'));
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ! Deixa a statusBar com caracteres brancos
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);



    return GetMaterialApp(
      title: 'Clean Architecture',
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: makeSplashPage, transition: Transition.fade),
        GetPage(name: '/login', page: makeLoginPage, transition: Transition.fadeIn),
        GetPage(name: '/signup', page: makeSignUpPage),
        GetPage(name: '/surveys', transition: Transition.fadeIn, page: () => Scaffold(body: Center(child: Text(R.strings.survey)),))
      ],
    );
  }
}
