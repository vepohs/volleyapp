import 'package:volleyapp/features/club_team/data/models/club_team_model.dart';

abstract class ClubTeamDataSource {
  Future<ClubTeamModel> addClubTeam({
    required String clubId,
    required String teamId,
  });

  Future<List<ClubTeamModel>> getClubTeamModelByClubId({required String clubId});
}
