abstract class SignInFormEvent{}

class EmailChanged extends SignInFormEvent{
  final String email;
  EmailChanged({required this.email});
}

class PasswordChanged extends SignInFormEvent{
  final String password;
  PasswordChanged({required this.password});
}

class DefaultSignInSubmitted extends SignInFormEvent{}

class GoogleSignInSubmitted extends SignInFormEvent{}