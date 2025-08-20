
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:volleyapp/app/router/app_router.dart';
import 'package:volleyapp/core/di/service_locator.dart';
import 'package:volleyapp/features/auth/domain/use_cases/sign_up_with_email/sign_up_with_email_usecase.dart';
import 'package:volleyapp/features/auth/presentation/blocs/sign_up_form_bloc/sign_up_form_bloc.dart';
import 'package:volleyapp/features/auth/presentation/blocs/sign_up_form_bloc/sign_up_form_event.dart';
import 'package:volleyapp/features/auth/presentation/blocs/sign_up_form_bloc/sign_up_form_state.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpFormBloc(
        signUpWithEmail: locator<SignUpWithEmailUseCase>(),
      ),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatelessWidget {
  const _SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpFormBloc, SignUpFormState>(
      listenWhen: (prev, curr) => prev.isSuccess != curr.isSuccess || prev.submitError != curr.submitError,
      listener: (context, state) {
        if (state.isSuccess == true) {
          // Navigation go_router
          context.go(AppRoutes.home);
        } else if (state.submitError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.submitError!)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Créer un compte')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<SignUpFormBloc, SignUpFormState>(
            buildWhen: (p, c) =>
            p.email != c.email ||
                p.password != c.password ||
                p.emailError != c.emailError ||
                p.passwordError != c.passwordError ||
                p.isSubmitting != c.isSubmitting,
            builder: (context, state) {
              final bloc = context.read<SignUpFormBloc>();
              return Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: state.emailError,
                    ),
                    onChanged: (v) => bloc.add(EmailChanged(v)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      errorText: state.passwordError,
                    ),
                    onChanged: (v) => bloc.add(PasswordChanged(v)),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () => bloc.add(SignUpSubmitted()),
                      child: state.isSubmitting
                          ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Text('Créer mon compte'),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.login),
                    child: const Text('Déjà un compte ? Se connecter'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
