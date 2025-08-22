class CreateTeamFormState {
  final String name;
  final String category;
  final String gender;
  final String level;
  final String avatarUrl;

  final bool isSubmitting;
  final bool isSuccess;

  final String? nameError;
  final String? categoryError;
  final String? genderError;
  final String? levelError;

  final String? errorMessage;

  const CreateTeamFormState({
    this.name = '',
    this.category = '',
    this.gender = '',
    this.level = '',
    this.avatarUrl = '',
    this.isSubmitting = false,
    this.isSuccess = false,
    this.nameError,
    this.categoryError,
    this.genderError,
    this.levelError,
    this.errorMessage,
  });

  CreateTeamFormState copyWith({
    String? name,
    String? category,
    String? gender,
    String? level,
    String? avatarUrl,
    bool? isSubmitting,
    bool? isSuccess,
    String? nameError,
    String? categoryError,
    String? genderError,
    String? levelError,
    String? errorMessage,
  }) {
    return CreateTeamFormState(
      name: name ?? this.name,
      category: category ?? this.category,
      gender: gender ?? this.gender,
      level: level ?? this.level,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      nameError: nameError,
      categoryError: categoryError,
      genderError: genderError,
      levelError: levelError,
      errorMessage: errorMessage,
    );
  }
}
