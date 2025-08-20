import 'package:volleyapp/core/form/states/email_state.dart';
import 'package:volleyapp/core/form/states/password_state.dart';
import 'package:volleyapp/features/auth/presentation/blocs/sign_up_form_bloc/sign_up_form_event.dart';

class SignUpFormState implements EmailState, PasswordState {

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


  SignUpFormState({
    required this.email,
    required this.password,
    this.emailError,
    this.passwordError,
    required this.isSubmitting,
    required this.isSuccess,
    this.submitError,
  });

  factory SignUpFormState.initial() => SignUpFormState(
    email: 'test.test@test.com',
    password: 'azertyR',
    emailError: null,
    passwordError: null,
    isSubmitting: false,
    isSuccess: null,
    submitError: null,
  );

  SignUpFormState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    bool? isSubmitting,
    bool? isSuccess,
    String? submitError,
  }) {
    return SignUpFormState(
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