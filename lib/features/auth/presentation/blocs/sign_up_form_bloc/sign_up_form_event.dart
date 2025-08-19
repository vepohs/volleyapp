abstract class SignUpFormEvent {}

class EmailChanged extends SignUpFormEvent {
  final String email;
  EmailChanged(this.email);
}

class PasswordChanged extends SignUpFormEvent {
  final String password;
  PasswordChanged(this.password);
}

class SignUpSubmitted extends SignUpFormEvent {}
