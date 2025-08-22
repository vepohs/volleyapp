import 'package:volleyapp/core/constants/firestore_fields.dart';
import 'package:volleyapp/core/mappers/base_mapper.dart';
import 'package:volleyapp/features/club_team/data/models/club_team_model.dart';

class ClubTeamJsonMapper
    implements BaseMapper<Map<String, dynamic>, ClubTeamModel> {
  @override
  ClubTeamModel from(Map<String, dynamic> input) {
    return ClubTeamModel(
      id: input[FirestoreClubTeamFields.id] as String,
      clubId: input[FirestoreClubTeamFields.clubId] as String,
      teamId: input[FirestoreClubTeamFields.teamId] as String,
    );
  }

  @override
  Map<String, dynamic> to(ClubTeamModel output) {
    return {
      FirestoreClubTeamFields.id: output.id,
      FirestoreClubTeamFields.clubId: output.clubId,
      FirestoreClubTeamFields.teamId: output.teamId,
    };
  }
}
