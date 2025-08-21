enum ClubJoinRequestStatus { pending, approved, rejected, canceled }

class ClubJoinRequest {
  final String id;
  final String clubId;
  final String userId;
  final ClubJoinRequestStatus status;
  final DateTime createdAt;
  final DateTime? decidedAt;

  const ClubJoinRequest({
    required this.id,
    required this.clubId,
    required this.userId,
    required this.status,
    required this.createdAt,
    this.decidedAt,
  });
}
