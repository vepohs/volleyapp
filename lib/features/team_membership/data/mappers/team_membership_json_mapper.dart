import 'package:volleyapp/core/mappers/base_mapper.dart';
import 'package:volleyapp/features/team_membership/data/models/team_membership_model.dart';
import 'package:volleyapp/core/constants/firestore_fields.dart';

class TeamMembershipJsonMapper
    implements BaseMapper<Map<String, dynamic>, TeamMembershipModel> {
  @override
  TeamMembershipModel from(Map<String, dynamic> input) {
    return TeamMembershipModel(
      id: input[FirestoreTeamMembershipFields.id] as String,
      teamId: input[FirestoreTeamMembershipFields.teamId] as String,
      userId: input[FirestoreTeamMembershipFields.userId] as String,
      joinedAt: DateTime.parse(input[FirestoreTeamMembershipFields.joinedAt] as String),
    );
  }

  @override
  Map<String, dynamic> to(TeamMembershipModel output) {
    return {
      FirestoreTeamMembershipFields.id: output.id,
      FirestoreTeamMembershipFields.teamId: output.teamId,
      FirestoreTeamMembershipFields.userId: output.userId,
      FirestoreTeamMembershipFields.joinedAt: output.joinedAt.toIso8601String(),
    };
  }
}
