import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/core/form/states/password_state.dart';

class PasswordField<TBloc extends BlocBase<TState>,TState extends PasswordState>
    extends StatelessWidget {
  final void Function(String value) onChanged;

  const PasswordField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
        TBloc,
        TState,
        ({String password, String? error, bool submitting})>(
      selector: (s) => (
      password: s.password,
      error: s.passwordError,
      submitting: s.isSubmitting,
      ),
      builder: (_, slice) {
        return TextFormField(
          enabled: !slice.submitting,
          initialValue: slice.password,
          onChanged: onChanged,
          obscureText: true,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          decoration: InputDecoration(
            labelText: "Mot de passe",
            errorText: slice.error,
          ),
        );
      },
    );
  }
}