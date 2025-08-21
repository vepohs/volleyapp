import 'package:volleyapp/core/mappers/base_mapper.dart';
import 'package:volleyapp/features/team/data/models/team_model.dart';
import 'package:volleyapp/features/team/domain/entities/team.dart';

class TeamMapper implements BaseMapper<TeamModel, Team> {
  @override
  Team from(TeamModel input) {
    return Team(
      id: input.id,
      name: input.name,
      category: input.category,
      gender: input.gender,
      level: input.level,
      avatarUrl: input.avatarUrl,
    );
  }

  @override
  TeamModel to(Team output) {
    return TeamModel(
      id: output.id,
      name: output.name,
      category: output.category,
      gender: output.gender,
      level: output.level,
      avatarUrl: output.avatarUrl,
    );
  }
}
