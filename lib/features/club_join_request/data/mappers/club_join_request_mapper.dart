import 'package:volleyapp/core/constants/club_join_request_values.dart';
import 'package:volleyapp/core/mappers/base_mapper.dart';
import 'package:volleyapp/features/club_join_request/data/models/club_join_request_model.dart';
import 'package:volleyapp/features/club_join_request/domain/entities/club_join_request.dart';

class ClubJoinRequestMapper
    implements BaseMapper<ClubJoinRequestModel, ClubJoinRequest> {
  @override
  ClubJoinRequest from(ClubJoinRequestModel m) {
    return ClubJoinRequest(
      id: m.id,
      clubId: m.clubId,
      userId: m.userId,
      status: _statusFromString(m.status),
      createdAt: m.createdAt,
      decidedAt: m.decidedAt,
    );
  }

  @override
  ClubJoinRequestModel to(ClubJoinRequest e) {
    return ClubJoinRequestModel(
      id: e.id,
      clubId: e.clubId,
      userId: e.userId,
      status: _statusToString(e.status),
      createdAt: e.createdAt,
      decidedAt: e.decidedAt,
    );
  }

  ClubJoinRequestStatus _statusFromString(String s) {
    switch (s) {
      case ClubJoinRequestStatusValues.approved:
        return ClubJoinRequestStatus.approved;
      case ClubJoinRequestStatusValues.rejected:
        return ClubJoinRequestStatus.rejected;
      case ClubJoinRequestStatusValues.canceled:
        return ClubJoinRequestStatus.canceled;
      case ClubJoinRequestStatusValues.pending:
      default:
        return ClubJoinRequestStatus.pending;
    }
  }

  String _statusToString(ClubJoinRequestStatus st) {
    switch (st) {
      case ClubJoinRequestStatus.pending:
        return ClubJoinRequestStatusValues.pending;
      case ClubJoinRequestStatus.approved:
        return ClubJoinRequestStatusValues.approved;
      case ClubJoinRequestStatus.rejected:
        return ClubJoinRequestStatusValues.rejected;
      case ClubJoinRequestStatus.canceled:
        return ClubJoinRequestStatusValues.canceled;
    }
  }
}
