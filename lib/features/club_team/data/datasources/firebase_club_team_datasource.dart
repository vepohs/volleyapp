import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volleyapp/core/constants/firestore_collections.dart';
import 'package:volleyapp/features/club_team/data/datasources/club_team_datasource.dart';
import 'package:volleyapp/features/club_team/data/mappers/club_team_json_mapper.dart';
import 'package:volleyapp/features/club_team/data/models/club_team_model.dart';

class FirebaseClubTeamDatasource implements ClubTeamDataSource {
  final FirebaseFirestore firestore;
  final ClubTeamJsonMapper _jsonMapper = ClubTeamJsonMapper();

  FirebaseClubTeamDatasource({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _clubTeamsCol =>
      firestore.collection(FirestoreCollections.clubTeams);

  @override
  Future<ClubTeamModel> addClubTeam({
    required String clubId,
    required String teamId,
  }) async {
    final docRef = _clubTeamsCol.doc();
    final generatedId = docRef.id;

    final clubTeam = ClubTeamModel(
      id: generatedId,
      clubId: clubId,
      teamId: teamId,
    );

    await docRef.set(_jsonMapper.to(clubTeam));

    return clubTeam;
  }

}
