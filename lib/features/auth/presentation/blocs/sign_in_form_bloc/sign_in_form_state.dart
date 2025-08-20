import 'package:volleyapp/core/form/states/email_state.dart';
import 'package:volleyapp/core/form/states/password_state.dart';

class SignInFormState implements PasswordState, EmailState {

  @override
  final String email;
  @override
  final String? emailError;

  @override
  final String password;
  @override
  final String? passwordError;

  @override
  final bool isSubmitting;

  final bool? isSuccess;
  final String? submitError;

  SignInFormState({
    required this.email,
    required this.password,
    this.emailError,
    this.passwordError,
    required this.isSubmitting,
    required this.isSuccess,
    this.submitError,
  });

  factory SignInFormState.initial() => SignInFormState(
  email: 'test.test@test.com',
  password: 'azertyR',
  emailError: null,
  passwordError: null,
  isSubmitting: false,
  isSuccess: null,
  submitError: null,
  );

  SignInFormState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    bool? isSubmitting,
    bool? isSuccess,
    String? submitError,
  }) {
    return SignInFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError,
      passwordError: passwordError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      submitError: submitError,
    );
  }

}