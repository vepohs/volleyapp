import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volleyapp/core/mappers/base_mapper.dart';
import 'package:volleyapp/core/constants/firestore_fields.dart';
import 'package:volleyapp/features/club_join_request/data/models/club_join_request_model.dart';


class ClubJoinRequestJsonMapper
    implements BaseMapper<Map<String, dynamic>, ClubJoinRequestModel> {
  @override
  ClubJoinRequestModel from(Map<String, dynamic> input) {
    return ClubJoinRequestModel(
      id: input[FirestoreClubJoinRequestFields.id] as String,
      clubId: input[FirestoreClubJoinRequestFields.clubId] as String,
      userId: input[FirestoreClubJoinRequestFields.userId] as String,
      status: input[FirestoreClubJoinRequestFields.status] as String,
      createdAt: _toDateTime(input[FirestoreClubJoinRequestFields.createdAt])!,
      decidedAt: _toDateTime(input[FirestoreClubJoinRequestFields.decidedAt]),
    );
  }

  @override
  Map<String, dynamic> to(ClubJoinRequestModel output) {
    return {
      FirestoreClubJoinRequestFields.id: output.id,
      FirestoreClubJoinRequestFields.clubId: output.clubId,
      FirestoreClubJoinRequestFields.userId: output.userId,
      FirestoreClubJoinRequestFields.status: output.status,
      FirestoreClubJoinRequestFields.createdAt: output.createdAt.toIso8601String(),
      FirestoreClubJoinRequestFields.decidedAt: output.decidedAt?.toIso8601String(),
    };
  }

  DateTime? _toDateTime(dynamic v) {
    if (v == null) return null;
    if (v is Timestamp) return v.toDate();
    if (v is String) return DateTime.parse(v);
    return null;
  }
}
