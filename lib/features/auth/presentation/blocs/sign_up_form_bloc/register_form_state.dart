class RegisterFormState {

  final String email;
  final String? emailError;
  final String password;
  final String? passwordError;
  final bool isSubmitting;
  final bool? isSuccess;

  final String? submitError;


  RegisterFormState({
    required this.email,
    required this.password,
    this.emailError,
    this.passwordError,
    required this.isSubmitting,
    required this.isSuccess,
    this.submitError,
  });

  factory RegisterFormState.initial() => RegisterFormState(
    email: '',
    password: '',
    emailError: null,
    passwordError: null,
    isSubmitting: false,
    isSuccess: null,
    submitError: null,
  );

  RegisterFormState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    bool? isSubmitting,
    bool? isSuccess,
    String? submitError,
  }) {
    return RegisterFormState(
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