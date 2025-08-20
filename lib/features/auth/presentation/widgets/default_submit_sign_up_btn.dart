

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/features/auth/presentation/blocs/sign_up_form_bloc/sign_up_form_bloc.dart';
import 'package:volleyapp/features/auth/presentation/blocs/sign_up_form_bloc/sign_up_form_event.dart';
import 'package:volleyapp/features/auth/presentation/blocs/sign_up_form_bloc/sign_up_form_state.dart';

class DefaultSubmitSignUpBtn extends StatelessWidget {
  const DefaultSubmitSignUpBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpFormBloc, SignUpFormState> (
      buildWhen: (prev, curr) =>
      prev.isSubmitting != curr.isSubmitting ||
          prev.emailError != curr.emailError ||
          prev.passwordError != curr.passwordError,

      builder: (context, state){
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.isSubmitting && state.emailError!='' && state.passwordError!=''
                ? null
                : (){
              context.read<SignUpFormBloc>().add(SignUpSubmitted());
            },
            child: state.isSubmitting
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Text("S'inscrire"),
          ),
        );
      },
    );
  }
}