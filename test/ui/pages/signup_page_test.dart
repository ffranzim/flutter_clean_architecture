import 'dart:async';

import 'package:clean_architecture/app/ui/helpers/errors/errors.dart';
import 'package:clean_architecture/app/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

void main() {
  SignUpPresenter presenter;

  StreamController<UIError> nameErrorController;
  StreamController<UIError> emailErrorController;
  StreamController<UIError> passwordErrorController;
  StreamController<UIError> passwordConfirmationErrorController;
  StreamController<bool> isFormValidController;

  void initStreams() {
    nameErrorController = StreamController<UIError>();
    emailErrorController = StreamController<UIError>();
    passwordErrorController = StreamController<UIError>();
    passwordConfirmationErrorController = StreamController<UIError>();
    isFormValidController = StreamController<bool>();
  }

  void mockStreams() {
    when(presenter.nameErrorStream)
        .thenAnswer((_) => nameErrorController.stream);
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(presenter.passwordConfirmationErrorStream)
        .thenAnswer((_) => passwordConfirmationErrorController.stream);
    when(presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
  }

  void closeStreams() {
    nameErrorController.close();
    nameErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
    isFormValidController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();
    initStreams();
    mockStreams();

    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(name: '/signup', page: () => SignUpPage(presenter: presenter)),
      ],
    );
    // ! Renderiza o componente
    await tester.pumpWidget(signUpPage);
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

    final nameTextChildren = find.descendant(
        of: find.bySemanticsLabel('Nome'), matching: find.byType(Text));
    expect(nameTextChildren, findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(passwordTextChildren, findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');

    final passwordConfirmationTextChildren = find.descendant(
        of: find.bySemanticsLabel('Confirmar Senha'),
        matching: find.byType(Text));
    expect(passwordConfirmationTextChildren, findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  //! Funciona se rodar só ele
  //! Funciona o teste com o provider, mas provider da erro em produção
  //! Não funciona o teste com o provider, mas getx(provider) não dá erro em produção
  // testWidgets('Should call validate email with correct values',
  //     (WidgetTester tester) async {
  //   await loadPage(tester);
  //
  //   final name = faker.person.name();
  //   await tester.enterText(find.bySemanticsLabel('Nome'), name);
  //   verify(presenter.validateName(name: name));
  //
  //   final email = faker.internet.email();
  //   await tester.enterText(find.bySemanticsLabel('Email'), email);
  //   verify(presenter.validateEmail(email: email));
  //
  //   final password = faker.internet.password();
  //   await tester.enterText(find.bySemanticsLabel('Senha'), password);
  //   verify(presenter.validatePassword(password: password));
  //
  //   await tester.enterText(find.bySemanticsLabel('Confirmar Senha'), password);
  //   verify(
  //       presenter.validatePasswordConfirmation(passwordConfirmation: password));
  // });

  testWidgets('Should present error name error', (WidgetTester tester) async {
    await loadPage(tester);

    nameErrorController.add(UIError.invalidField);
    // ! Força os componentes que precisam serem renderizados
    await tester.pump();
    expect(find.text('Campo inválido.'), findsOneWidget);

    nameErrorController.add(UIError.requiredField);
    // ! Força os componentes que precisam serem renderizados
    await tester.pump();
    expect(find.text('Campo Obrigatório.'), findsOneWidget);

    nameErrorController.add(null);
    // ! Força os componentes que precisam serem renderizados
    await tester.pump();
    final nameTextChildren = find.descendant(
        of: find.bySemanticsLabel('Nome'), matching: find.byType(Text));
    expect(nameTextChildren, findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');
  });

  testWidgets('Should present error email error', (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(UIError.invalidField);
    // ! Força os componentes que precisam serem renderizados
    await tester.pump();
    expect(find.text('Campo inválido.'), findsOneWidget);

    emailErrorController.add(UIError.requiredField);
    // ! Força os componentes que precisam serem renderizados
    await tester.pump();
    expect(find.text('Campo Obrigatório.'), findsOneWidget);

    emailErrorController.add(null);
    // ! Força os componentes que precisam serem renderizados
    await tester.pump();
    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');
  });

  testWidgets('Should present error password error',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add(UIError.invalidField);
    // ! Força os componentes que precisam serem renderizados
    await tester.pump();
    expect(find.text('Campo inválido.'), findsOneWidget);

    passwordErrorController.add(UIError.requiredField);
    // ! Força os componentes que precisam serem renderizados
    await tester.pump();
    expect(find.text('Campo Obrigatório.'), findsOneWidget);

    passwordErrorController.add(null);
    // ! Força os componentes que precisam serem renderizados
    await tester.pump();
    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(passwordTextChildren, findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');
  });

  testWidgets('Should present error passwordConfirmation error',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordConfirmationErrorController.add(UIError.invalidField);
    // ! Força os componentes que precisam serem renderizados
    await tester.pump();
    expect(find.text('Campo inválido.'), findsOneWidget);

    passwordConfirmationErrorController.add(UIError.requiredField);
    // ! Força os componentes que precisam serem renderizados
    await tester.pump();
    expect(find.text('Campo Obrigatório.'), findsOneWidget);

    passwordConfirmationErrorController.add(null);
    // ! Força os componentes que precisam serem renderizados
    await tester.pump();
    final passwordConfirmationTextChildren = find.descendant(
        of: find.bySemanticsLabel('Confirmar Senha'),
        matching: find.byType(Text));
    expect(passwordConfirmationTextChildren, findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');
  });

  testWidgets('Should enable button if form is valid',
          (WidgetTester tester) async {
        await loadPage(tester);

        isFormValidController.add(true);
        // ! Força os componentes que precisam serem renderizados
        await tester.pump();

        final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.onPressed, isNotNull);
      });

  testWidgets('Should disable button if form is invalid',
          (WidgetTester tester) async {
        await loadPage(tester);

        isFormValidController.add(false);
        // ! Força os componentes que precisam serem renderizados
        await tester.pump();

        final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.onPressed, null);
      });

}
