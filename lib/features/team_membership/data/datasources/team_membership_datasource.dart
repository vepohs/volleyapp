import 'package:volleyapp/features/team_membership/data/models/team_membership_model.dart';

abstract class TeamMembershipDataSource {
  Future<TeamMembershipModel> addTeamMembership({
    required String teamId,
    required String userId,
  });
}
