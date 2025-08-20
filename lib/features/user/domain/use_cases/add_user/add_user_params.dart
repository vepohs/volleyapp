class AddUserParams {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final DateTime birthdate;
  final String? avatarUrl;

  AddUserParams({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.birthdate,
    this.avatarUrl,
  });
}
