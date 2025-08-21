class CreateClubState {
  final String clubName;
  final String? clubNameError;

  final bool isSubmitting;
  final bool? isSuccess;
  final String? submitError;

  const CreateClubState({
    required this.clubName,
    this.clubNameError,
    required this.isSubmitting,
    this.isSuccess,
    this.submitError,
  });

  factory CreateClubState.initial() => const CreateClubState(
    clubName: '',
    isSubmitting: false,
    isSuccess: null,
    submitError: null,
  );

  CreateClubState copyWith({
    String? clubName,
    String? clubNameError,
    bool? isSubmitting,
    bool? isSuccess,
    String? submitError,
  }) {
    return CreateClubState(
      clubName: clubName ?? this.clubName,
      clubNameError: clubNameError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      submitError: submitError,
    );
  }
}
