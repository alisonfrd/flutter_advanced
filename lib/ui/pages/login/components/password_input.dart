import 'package:curso_avancado/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 32),
      child: StreamBuilder<String?>(
          stream: presenter.passwordErrorStream,
          builder: (context, snapshot) {
            return TextFormField(
              decoration: InputDecoration(
                  labelText: 'Senha',
                  icon: Icon(
                    Icons.lock,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  errorText:
                      snapshot.data?.isEmpty == true ? null : snapshot.data),
              onChanged: presenter.validatePassword,
            );
          }),
    );
  }
}
