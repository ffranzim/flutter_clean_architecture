import 'package:clean_architecture/app/utils/i18n/i18n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../ui/components/spinner_dialog.dart';
import '../../components/components.dart';
import './components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;
  final Logger log = Logger();

  LoginPage({@required this.presenter});

  @override
  Widget build(BuildContext context) {
    void _hideKeyboard() {
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }

    return Scaffold(
      body: Builder(
        builder: (context) {
          presenter.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              showLoading(context: context);
            } else {
              hideLoading(context: context);
            }
          });

          presenter.mainErrorStream.listen((error) {
            if (error.isNotEmpty) {
              showErrorMessage(context: context, msg: error);
            }
          });

          presenter.navigateToStream.listen((page) {
            if (page?.isNotEmpty == true) {
              //! offAllNamed remove rodas as rotas e inclui uma nova
              Get.offAllNamed(page);
            }
          });

          Get.put(presenter);
          return GestureDetector(
            onTap: _hideKeyboard,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginHeader(),
                  const Headline1(text: 'login'),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Provider(
                      create: (_) => presenter,
                      child: Form(
                        child: Column(
                          children: [
                            EmailInput(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 32.0),
                              child: PasswordInput(),
                            ),
                            LoginButton(),
                            TextButton.icon(
                              onPressed: () => log.i('TextButton'),
                              icon: const Icon(Icons.person),
                              label: Text(R.strings.addAccount),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
