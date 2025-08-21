class TeamMembershipModel {
  final String id;
  final String teamId;
  final String userId;
  final DateTime joinedAt;

  const TeamMembershipModel({
    required this.id,
    required this.teamId,
    required this.userId,
    required this.joinedAt,
  });
}
