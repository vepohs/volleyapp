
import 'package:volleyapp/core/constants/firestore_fields.dart';
import 'package:volleyapp/core/mappers/base_mapper.dart';
import 'package:volleyapp/features/club_membership/data/models/club_membership_model.dart';

class ClubMembershipJsonMapper
    implements BaseMapper<Map<String, dynamic>, ClubMembershipModel> {
  @override
  ClubMembershipModel from(Map<String, dynamic> input) {
    return ClubMembershipModel(
      id: input[FirestoreClubMembershipFields.id] as String,
      clubId: input[FirestoreClubMembershipFields.clubId] as String,
      userId: input[FirestoreClubMembershipFields.userId] as String,
      roleId: input[FirestoreClubMembershipFields.roleId] as String,
      joinedAt: DateTime.parse(
        input[FirestoreClubMembershipFields.joinedAt] as String,
      ),
    );
  }

  @override
  Map<String, dynamic> to(ClubMembershipModel output) {
    return {
      FirestoreClubMembershipFields.id: output.id,
      FirestoreClubMembershipFields.clubId: output.clubId,
      FirestoreClubMembershipFields.userId: output.userId,
      FirestoreClubMembershipFields.roleId: output.roleId,
      FirestoreClubMembershipFields.joinedAt:
      output.joinedAt.toIso8601String(),
    };
  }
}
