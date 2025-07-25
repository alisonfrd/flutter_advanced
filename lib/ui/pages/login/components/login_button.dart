import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_presenter.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<bool?>(
        stream: presenter.isFormValidStream,
        builder: (context, snapshot) {
          return FilledButton(
            onPressed: snapshot.data == true ? presenter.auth : null,
            child: const Text(
              'Entrar',
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }
}
