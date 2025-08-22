import 'package:volleyapp/core/mappers/base_mapper.dart';
import 'package:volleyapp/features/club_team/data/models/club_team_model.dart';
import 'package:volleyapp/features/club_team/domain/entities/club_team.dart';

class ClubTeamMapper implements BaseMapper<ClubTeamModel, ClubTeam> {
  @override
  ClubTeam from(ClubTeamModel input) {
    return ClubTeam(
      id: input.id,
      clubId: input.clubId,
      teamId: input.teamId,
    );
  }

  @override
  ClubTeamModel to(ClubTeam output) {
    return ClubTeamModel(
      id: output.id,
      clubId: output.clubId,
      teamId: output.teamId,
    );
  }
}
