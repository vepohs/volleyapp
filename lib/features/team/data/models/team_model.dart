class TeamModel {
  final String id;
  final String name;
  final String category;
  final String gender;
  final String level;
  final String? avatarUrl;

  const TeamModel({
    required this.id,
    required this.name,
    required this.category,
    required this.gender,
    required this.level,
    this.avatarUrl,
  });
}
