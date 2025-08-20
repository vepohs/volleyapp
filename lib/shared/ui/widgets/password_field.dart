import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/core/form/states/password_state.dart';

class PasswordField<TBloc extends BlocBase<TState>,TState extends PasswordState>
    extends StatelessWidget {
  final void Function(String value) onChanged;

  const PasswordField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TBloc, TState>(
      buildWhen: (previous, current) =>
      previous.password != current.password ||
      previous.passwordError != current.passwordError ||
      previous.isSubmitting != current.isSubmitting,

      builder: (context, state) {
        return TextFormField(
          initialValue: state.password,
          onChanged: onChanged,
          enabled: !state.isSubmitting,
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Mot de passe",
            errorText: state.passwordError,
          ),
        );
      },
    );
  }
}
