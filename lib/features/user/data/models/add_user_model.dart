class AddUserDto {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String? avatarUrl;

  AddUserDto({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    this.avatarUrl,
  });
}