import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pages/login/login_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    const primaryColor = Color.fromRGBO(136, 14, 79, 1);
    const primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
    const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);

    return MaterialApp(
      title: '4Dev',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        primaryColorLight: primaryColorLight,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
            headlineLarge: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: primaryColorDark)),
        inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: primaryColorLight,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: primaryColor,
              ),
            ),
            alignLabelWithHint: true),

        filledButtonTheme: const FilledButtonThemeData(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(primaryColor),
                foregroundColor: WidgetStatePropertyAll(primaryColorLight),
                textStyle:
                    WidgetStatePropertyAll(TextStyle(color: Colors.white)),
                padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                )))),
        // buttonTheme: ButtonThemeData(
        //   colorScheme: const ColorScheme.light(
        //     primary: primaryColor,
        //   ),
        //   buttonColor: primaryColor,
        //   splashColor: primaryColorLight,
        //   padding: const EdgeInsets.symmetric(
        //     vertical: 10,
        //     horizontal: 20,
        //   ),
        //   textTheme: ButtonTextTheme.primary,
        //   shape:
        //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        // ),
      ),
      home: const LoginPage(
        presenter: null,
      ),
    );
  }
}
