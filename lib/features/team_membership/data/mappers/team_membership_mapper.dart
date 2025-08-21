import 'package:volleyapp/core/mappers/base_mapper.dart';
import 'package:volleyapp/features/team_membership/data/models/team_membership_model.dart';
import 'package:volleyapp/features/team_membership/domain/entities/team_membership.dart';

class TeamMembershipMapper
    implements BaseMapper<TeamMembershipModel, TeamMembership> {
  @override
  TeamMembership from(TeamMembershipModel input) {
    return TeamMembership(
      id: input.id,
      teamId: input.teamId,
      userId: input.userId,
      joinedAt: input.joinedAt,
    );
  }

  @override
  TeamMembershipModel to(TeamMembership output) {
    return TeamMembershipModel(
      id: output.id,
      teamId: output.teamId,
      userId: output.userId,
      joinedAt: output.joinedAt,
    );
  }
}
