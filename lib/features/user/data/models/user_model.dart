class UserModel {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final DateTime birthdate;
  final String? avatarUrl;
  final DateTime createdAt;
  final String roleId;
  final String? clubId;
  final String? teamId;

  UserModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.birthdate,
    this.avatarUrl,
    required this.createdAt,
    required this.roleId,
    this.clubId,
    this.teamId,
  });
}
