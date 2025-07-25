import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curso_avancado/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  late LoginPresenter presenter;
  late StreamController<String?> emailErrorController;
  late StreamController<String?> passwordErrorController;
  late StreamController<bool?> isFormValidController;
  late StreamController<bool?> isLoadingController;
  late StreamController<String?> mainErrorController;

  void initStreams() {
    emailErrorController = StreamController<String?>();
    passwordErrorController = StreamController<String?>();
    isFormValidController = StreamController<bool?>();
    isLoadingController = StreamController<bool?>();
    mainErrorController = StreamController<String?>();
  }

  void mockStreams() {
    when(() => presenter.emailErrorStream).thenAnswer(
      (_) => emailErrorController.stream,
    );
    when(() => presenter.passwordErrorStream).thenAnswer(
      (_) => passwordErrorController.stream,
    );
    when(() => presenter.isFormValidStream).thenAnswer(
      (_) => isFormValidController.stream,
    );
    when(() => presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
  }

  Future<void> loadpage(WidgetTester widgetTester) async {
    presenter = LoginPresenterSpy();
    initStreams();
    mockStreams();
    final loginPage = MaterialApp(
        home: LoginPage(
      presenter: presenter,
    ));
    //arrange
    await widgetTester.pumpWidget(loginPage);
  }

  tearDown(
    () {
      closeStreams();
    },
  );

  testWidgets(
    'Should load with corret initial state',
    (widgetTester) async {
      await loadpage(widgetTester);
      final emailTextChildren = find.descendant(
          of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
      expect(
        emailTextChildren,
        findsOneWidget,
        reason:
            'When a TextFormFiel has only one text child, means it has no errors, since one of the childs in always the label text',
      );
      final passwordTextChildren = find.descendant(
          of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
      expect(
        passwordTextChildren,
        findsOneWidget,
        reason:
            'When a TextFormFiel has only one text child, means it has no errors, since one of the childs in always the label text',
      );

      final button =
          widgetTester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, null);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets(
    'Should call validate with corret values',
    (widgetTester) async {
      await loadpage(widgetTester);
      final email = faker.internet.email();
      await widgetTester.enterText(find.bySemanticsLabel('Email'), email);
      verify(
        () => presenter.validateEmail(email),
      ).called(1);

      final password = faker.internet.password();
      await widgetTester.enterText(find.bySemanticsLabel('Senha'), password);
      verify(
        () => presenter.validatePassword(password),
      ).called(1);
    },
  );

  testWidgets('Should present  error if email is invalid ',
      (widgetTester) async {
    await loadpage(widgetTester);
    emailErrorController.add('any error');
    await widgetTester.pump();

    expect(
      find.text('any error'),
      findsOneWidget,
    );
  });
  testWidgets('Should present no error if email is valid ',
      (widgetTester) async {
    await loadpage(widgetTester);
    emailErrorController.add(null);
    await widgetTester.pump();

    expect(
      find.descendant(
          of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });
  testWidgets('Should present no error if email is valid ',
      (widgetTester) async {
    await loadpage(widgetTester);
    emailErrorController.add('');
    await widgetTester.pump();

    expect(
      find.descendant(
          of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('Should present  error if password is invalid ',
      (widgetTester) async {
    await loadpage(widgetTester);
    passwordErrorController.add('any error');
    await widgetTester.pump();

    expect(
      find.text('any error'),
      findsOneWidget,
    );
  });
  testWidgets('Should present no error if password is valid ',
      (widgetTester) async {
    await loadpage(widgetTester);
    passwordErrorController.add(null);
    await widgetTester.pump();

    expect(
      find.descendant(
          of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });
  testWidgets('Should present no error if password is valid ',
      (widgetTester) async {
    await loadpage(widgetTester);
    passwordErrorController.add('');
    await widgetTester.pump();

    expect(
      find.descendant(
          of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });
  testWidgets('Should enable button if form is valid', (widgetTester) async {
    await loadpage(widgetTester);
    isFormValidController.add(true);
    await widgetTester.pump();

    final button = widgetTester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Should enable button if form is invalid', (widgetTester) async {
    await loadpage(widgetTester);
    isFormValidController.add(false);
    await widgetTester.pump();

    final button = widgetTester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, null);
  });

  testWidgets('Should call authentication on form subimit',
      (WidgetTester tester) async {
    await loadpage(tester);
    when(
      () => presenter.auth(),
    ).thenAnswer((_) async {});

    isFormValidController.add(true);
    await tester.pump();
    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    verify(() => presenter.auth()).called(1);
  });
  testWidgets('Should present loading', (WidgetTester tester) async {
    await loadpage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  testWidgets('Should present error  messa if authenticatoin fails',
      (WidgetTester tester) async {
    await loadpage(tester);

    mainErrorController.add('main error');
    await tester.pump();

    expect(find.text('main error'), findsOneWidget);
  });

  testWidgets('Should close streams on dispose', (WidgetTester tester) async {
    await loadpage(tester);

    addTearDown(() {
      verify(() => presenter.dispose()).called(1);
    });
  });
}
