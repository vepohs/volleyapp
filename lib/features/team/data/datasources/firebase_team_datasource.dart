import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volleyapp/core/constants/firestore_collections.dart';
import 'package:volleyapp/features/team/data/datasources/team_datasource.dart';
import 'package:volleyapp/features/team/data/mappers/team_json_mapper.dart';
import 'package:volleyapp/features/team/data/models/team_model.dart';
import 'package:volleyapp/features/team/errors/team_exception.dart';

class FirebaseTeamDataSource implements TeamDataSource {
  final FirebaseFirestore firestore;
  final TeamJsonMapper _jsonMapper = TeamJsonMapper();

  FirebaseTeamDataSource({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _teamsCol =>
      firestore.collection(FirestoreCollections.teams);

  @override
  Future<TeamModel> addTeam({
    required String name,
    required String category,
    required String gender,
    required String level,
    String? avatarUrl,
  }) async {
    try {
      final docRef = _teamsCol.doc();
      final generatedId = docRef.id;

      final team = TeamModel(
        id: generatedId,
        name: name,
        category: category,
        gender: gender,
        level: level,
        avatarUrl: avatarUrl,
      );

      await docRef.set(_jsonMapper.to(team));

      return team;
    } on FirebaseException catch (e) {
      throw AddTeamException("Firestore error: ${e.message}");
    } catch (e) {
      throw AddTeamException("Erreur inattendue: $e");
    }
  }
}
