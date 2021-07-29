import 'package:clean_architecture/app/ui/helpers/errors/errors.dart';
import 'package:clean_architecture/app/ui/helpers/i18n/i18n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../components/components.dart';
import 'components/components.dart';
import 'signup_presenter.dart';

class SignUpPage extends StatelessWidget {
  final Logger log = Logger();

  final SignUpPresenter presenter;

  SignUpPage({@required this.presenter});

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
          Get.put(presenter);

          presenter.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              showLoading(context: context);
            } else {
              hideLoading(context: context);
            }
          });

          presenter.mainErrorStream.listen((error) {
            if (error != null) {
              showErrorMessage(context: context, msg: error.description);
            }
          });

          presenter.navigateToStream.listen((page) {
            if (page?.isNotEmpty == true) {
              //! offAllNamed remove rodas as rotas e inclui uma nova
              Get.offAllNamed(page);
            }
          });

          return GestureDetector(
            onTap: _hideKeyboard,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginHeader(),
                  Headline1(text: R.strings.addAccount),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Form(
                      child: Column(
                        children: [
                          NameInput(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: EmailInput(),
                          ),
                          PasswordInput(),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 32.0),
                            child: PasswordConfirmationInput(),
                          ),
                          SignUpButton(),
                          TextButton.icon(
                            onPressed: presenter.goToLogin ,
                            icon: const Icon(Icons.login),
                            label: Text(R.strings.login),
                          )
                        ],
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
