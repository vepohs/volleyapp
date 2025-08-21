class AddTeamParams {
  final String name;
  final String category;
  final String gender;
  final String level;
  final String? avatarUrl;

  const AddTeamParams({
    required this.name,
    required this.category,
    required this.gender,
    required this.level,
    this.avatarUrl,
  });
}
