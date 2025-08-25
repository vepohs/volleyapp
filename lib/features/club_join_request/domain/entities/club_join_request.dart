
import 'package:volleyapp/features/user/domain/entities/user.dart';

enum ClubJoinRequestStatus { pending, approved, rejected, canceled }

class ClubJoinRequest {
  final String id;
  final String clubId;
  final User user;
  final ClubJoinRequestStatus status;
  final DateTime createdAt;
  final DateTime? decidedAt;

  const ClubJoinRequest({
    required this.id,
    required this.user,
    required this.clubId,
    required this.status,
    required this.createdAt,
    this.decidedAt,
  });
}
