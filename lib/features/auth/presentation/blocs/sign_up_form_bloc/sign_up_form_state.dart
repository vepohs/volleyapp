class SignUpFormState {

  final String email;
  final String? emailError;
  final String password;
  final String? passwordError;
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
    email: '',
    password: '',
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