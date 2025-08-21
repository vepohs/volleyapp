import 'package:volleyapp/core/mappers/base_mapper.dart';
import 'package:volleyapp/features/team/data/models/team_model.dart';
import 'package:volleyapp/core/constants/firestore_fields.dart';

class TeamJsonMapper implements BaseMapper<Map<String, dynamic>, TeamModel> {
  @override
  TeamModel from(Map<String, dynamic> input) {
    return TeamModel(
      id: input[FirestoreTeamFields.id] as String,
      name: input[FirestoreTeamFields.name] as String,
      category: input[FirestoreTeamFields.category] as String,
      gender: input[FirestoreTeamFields.gender] as String,
      level: input[FirestoreTeamFields.level] as String,
      avatarUrl: input[FirestoreTeamFields.avatarUrl] as String?,
    );
  }

  @override
  Map<String, dynamic> to(TeamModel output) {
    return {
      FirestoreTeamFields.id: output.id,
      FirestoreTeamFields.name: output.name,
      FirestoreTeamFields.category: output.category,
      FirestoreTeamFields.gender: output.gender,
      FirestoreTeamFields.level: output.level,
      FirestoreTeamFields.avatarUrl: output.avatarUrl,
    };
  }
}
