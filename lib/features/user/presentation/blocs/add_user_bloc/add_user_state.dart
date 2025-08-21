class AddUserState {

  final String firstName;
  final String? firstNameError;

  final String lastName;
  final String? lastNameError;

  final DateTime? birthdate;
  final String? birthdateError;

  final String? avatarUrl;
  final String? avatarUrlError;

  final bool isSubmitting;
  final String? submitError;
  final bool? isSuccess;

  AddUserState({
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    this.avatarUrl,
    this.lastNameError,
    this.firstNameError,
    this.birthdateError,
    this.avatarUrlError,
    required this.isSubmitting,
    this.submitError,
    required this.isSuccess,
  });

  factory AddUserState.initial() => AddUserState(
    firstName: 'matthias',
    lastName: 'Voiture',
    birthdate: null,
    lastNameError: null,
    firstNameError: null,
    isSubmitting: false,
    isSuccess: null,
  );

  AddUserState copyWith({
    String? firstName,
    String? firstNameError,
    String? lastName,
    String? lastNameError,
    DateTime? birthdate,
    String? birthdateError,
    String? avatarUrl,
    String? avatarUrlError,
    bool? isSubmitting,
    String? submitError,
    bool? isSuccess,
  }) {
    return AddUserState(
      firstName: firstName ?? this.firstName,
      firstNameError: firstNameError,
      lastName: lastName ?? this.lastName,
      lastNameError: lastNameError,
      birthdate: birthdate ?? this.birthdate,
      birthdateError: birthdateError,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarUrlError: avatarUrlError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: submitError,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}