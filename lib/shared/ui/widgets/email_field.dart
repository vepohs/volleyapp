import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/core/form/states/email_state.dart';

class EmailField<TBloc extends BlocBase<TState>, TState extends EmailState>
    extends StatelessWidget {

  final void Function(String value) onChanged;

  const EmailField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TBloc, TState, ({String email, String? error, bool submitting})>(
      selector: (state) => (email: state.email, error: state.emailError, submitting: state.isSubmitting),
      builder: (_, slice) {
        return TextFormField(
          enabled: !slice.submitting,
          initialValue: slice.email,
          onChanged: onChanged,
          obscureText: false,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          decoration: InputDecoration(
            labelText: "Adresse e-mail",
            errorText: slice.error,
          ),
        );
      },
    );
  }
}
