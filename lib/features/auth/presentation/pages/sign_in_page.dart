
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:volleyapp/app/di/service_locator.dart';
import 'package:volleyapp/app/routing/app_route.dart';
import 'package:volleyapp/features/auth/domain/use_cases/sign_in_with_email/sign_in_with_email_use_case.dart';
import 'package:volleyapp/features/auth/domain/use_cases/sign_in_with_google/sign_in_with_google.dart';
import 'package:volleyapp/features/auth/presentation/blocs/sign_in_form_bloc/sign_in_form_bloc.dart';
import 'package:volleyapp/features/auth/presentation/blocs/sign_in_form_bloc/sign_in_form_event.dart';
import 'package:volleyapp/features/auth/presentation/blocs/sign_in_form_bloc/sign_in_form_state.dart';
import 'package:volleyapp/shared/ui/widgets/email_field.dart';
import 'package:volleyapp/shared/ui/widgets/password_field.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInFormBloc(
        signInWithEmailUseCase: locator<SignInWithEmailUseCase>(),
        signInWithGoogleUseCase: locator<SignInWithGoogleUseCase>(),
      ),
      child: const _SignInView(),
    );
  }
}

class _SignInView extends StatelessWidget {
const _SignInView();

@override
Widget build(BuildContext context) {
  return BlocListener<SignInFormBloc, SignInFormState>(
    listenWhen: (prev, curr) =>
    prev.isSuccess != curr.isSuccess || prev.submitError != curr.submitError,
    listener: (context, state) {
      if (state.submitError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.submitError!)),
        );
      }
      // plus de context.go() → GoRouter gère la redirection
    },
    child: Scaffold(
      appBar: AppBar(title: const Text("Connexion")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            EmailField<SignInFormBloc, SignInFormState>(
              onChanged: (value) {
                context.read<SignInFormBloc>().add(EmailChanged(email: value));
              },
            ),
            const SizedBox(height: 16),
            PasswordField<SignInFormBloc, SignInFormState>(
              onChanged: (value) {
                context.read<SignInFormBloc>().add(PasswordChanged(password: value));
              },
            ),
            const SizedBox(height: 24),

            // Bouton Connexion
            BlocBuilder<SignInFormBloc, SignInFormState>(
              buildWhen: (prev, curr) =>
              prev.isSubmitting != curr.isSubmitting,
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () => context.read<SignInFormBloc>().add(DefaultSignInSubmitted()),
                    child: state.isSubmitting
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Text("Se connecter"),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Bouton Google
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<SignInFormBloc>().add(GoogleSignInSubmitted());
                },
                child: const Text("Se connecter avec Google"),
              ),
            ),

            const SizedBox(height: 16),

            // Lien vers SignUp (on garde, c’est pas une redirection automatique)
            ElevatedButton(
              onPressed: () => context.go(AppRoute.signUp.path),
              child: const Text("Créer un compte"),
            ),
          ],
        ),
      ),
    ),
  );
}
}
