import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../ui/components/components.dart';
import 'factories/factories.dart';

void main() => runApp(App());

class App extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    // ! Deixa a statusBar com caracteres brancos
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return GetMaterialApp(
      title: 'Clean Architecture',
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: makeLoginPage),
        GetPage(name: '/surveys', page: () => const Scaffold(body: Text('Enquetes'),)),
      ],
    );
  }
}
