import 'package:clean_architecture/app/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helpers/helpers.dart';

class NameInput extends StatelessWidget {
  final presenter = Get.find<SignUpPresenter>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UIError>(
      stream: presenter.nameErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: R.strings.name,
            //TODO não consegui fazer com o ThemeData
            icon: Icon(
              Icons.person,
              color: Theme.of(context).primaryColor,
            ),
            errorText: snapshot.hasData ? snapshot.data.description : null,
          ),
          keyboardType: TextInputType.name,
          onChanged: (name) => presenter.validateName(name: name),
        );
      },
    );
  }
}
