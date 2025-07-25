import 'package:curso_avancado/ui/pages/pages.dart';
import 'package:flutter/material.dart';

import 'package:curso_avancado/ui/components/components.dart';
import 'package:provider/provider.dart';

import 'components/components.dart';
import 'components/email_input.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter? presenter;
  const LoginPage({super.key, required this.presenter});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    widget.presenter!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        widget.presenter!.isLoadingStream.listen(
          (isLoading) {
            if (isLoading!) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          },
        );

        widget.presenter!.mainErrorStream.listen((error) {
          if (error != null) {
            showErrorMessage(context, error);
          }
        });
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LoginHeader(),
              const Headline1(text: 'Login'),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Provider<LoginPresenter>(
                  create: (_) => widget.presenter!,
                  child: Form(
                      child: Column(
                    children: [
                      const EmailInput(),
                      const PasswordInput(),
                      const LoginButton(),
                      TextButton.icon(
                        onPressed: () {},
                        label: Text(
                          'Criar conta',
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark),
                        ),
                        icon: Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      )
                    ],
                  )),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
