class ClubMembershipModel {
  final String id;
  final String clubId;
  final String userId;
  final String roleId;
  final DateTime joinedAt;

  const ClubMembershipModel({
    required this.id,
    required this.clubId,
    required this.userId,
    required this.roleId,
    required this.joinedAt,
  });
}
