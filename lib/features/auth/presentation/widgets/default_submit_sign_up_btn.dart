import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/features/auth/presentation/blocs/sign_up_form_bloc/sign_up_form_bloc.dart';
import 'package:volleyapp/features/auth/presentation/blocs/sign_up_form_bloc/sign_up_form_event.dart';
import 'package:volleyapp/features/auth/presentation/blocs/sign_up_form_bloc/sign_up_form_state.dart';

class DefaultSubmitSignUpBtn extends StatelessWidget {
  const DefaultSubmitSignUpBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SignUpFormBloc, SignUpFormState,
        ({bool submitting, String email, String? emailError, String password, String? passwordError})>(
      selector: (s) => (
      submitting: s.isSubmitting,
      email: s.email,
      emailError: s.emailError,
      password: s.password,
      passwordError: s.passwordError,
      ),
      builder: (context, slice) {
        final hasErrors = slice.emailError != null || slice.passwordError != null;
        final isEmpty = slice.email.trim().isEmpty || slice.password.trim().isEmpty;
        final disabled = slice.submitting || hasErrors || isEmpty;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: disabled
                ? null
                : () => context.read<SignUpFormBloc>().add(SignUpSubmitted()),
            child: slice.submitting
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text("S'inscrire"),
          ),
        );
      },
    );
  }
}