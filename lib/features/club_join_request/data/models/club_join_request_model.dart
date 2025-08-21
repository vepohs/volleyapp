class ClubJoinRequestModel {
  final String id;
  final String clubId;
  final String userId;
  final String status;
  final DateTime createdAt;
  final DateTime? decidedAt;

  const ClubJoinRequestModel({
    required this.id,
    required this.clubId,
    required this.userId,
    required this.status,
    required this.createdAt,
    this.decidedAt,
  });
}
