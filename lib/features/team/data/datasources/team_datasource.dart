import 'package:volleyapp/features/team/data/models/team_model.dart';

abstract class TeamDataSource {
  Future<TeamModel> addTeam({
    required String name,
    required String category,
    required String gender,
    required String level,
    String? avatarUrl,
  });
}
