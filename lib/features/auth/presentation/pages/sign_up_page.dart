import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:volleyapp/app/di/service_locator.dart';
import 'package:volleyapp/app/routing/app_route.dart';
import 'package:volleyapp/features/auth/domain/use_cases/sign_up_with_email/sign_up_with_email_usecase.dart';
import 'package:volleyapp/features/auth/presentation/blocs/sign_up_form_bloc/sign_up_form_bloc.dart';
import 'package:volleyapp/features/auth/presentation/blocs/sign_up_form_bloc/sign_up_form_event.dart';
import 'package:volleyapp/features/auth/presentation/blocs/sign_up_form_bloc/sign_up_form_state.dart';
import 'package:volleyapp/features/auth/presentation/widgets/default_submit_sign_up_btn.dart';
import 'package:volleyapp/shared/ui/widgets/email_field.dart';
import 'package:volleyapp/shared/ui/widgets/password_field.dart';

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
  const _SignUpView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpFormBloc, SignUpFormState>(
      listenWhen: (prev, curr) =>
      prev.isSuccess != curr.isSuccess || prev.submitError != curr.submitError,
      listener: (context, state) {
        if (state.submitError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.submitError!)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Inscription")),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              EmailField<SignUpFormBloc, SignUpFormState>(
                onChanged: (value) {
                  context.read<SignUpFormBloc>().add(EmailChanged(value));
                },
              ),
              const SizedBox(height: 16),
              PasswordField<SignUpFormBloc, SignUpFormState>(
                onChanged: (value) {
                  context.read<SignUpFormBloc>().add(PasswordChanged(value));
                },
              ),
              const SizedBox(height: 24),
              DefaultSubmitSignUpBtn(),

              ElevatedButton(
                onPressed: () => context.go(AppRoute.signIn.path),
                child: const Text("Login Screen"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

