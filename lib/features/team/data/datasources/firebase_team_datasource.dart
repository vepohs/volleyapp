import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volleyapp/core/constants/firestore_collections.dart';
import 'package:volleyapp/core/constants/firestore_fields.dart';
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

  @override
  Future<List<TeamModel>> getAllTeamByIds(List<String> ids) async {
    try {
      if (ids.isEmpty) return [];
      final snapshots = await Future.wait(
        ids.map((id) => _teamsCol.doc(id).get()),
      );

      return snapshots
          .where((doc) => doc.exists)
          .map((doc) {
            final data = doc.data();
            if (data == null) return null;
            final withId = <String, dynamic>{
              ...data,
              FirestoreTeamFields.id: doc.id,
            };

            return _jsonMapper.from(withId);
          })
          .whereType<TeamModel>()
          .toList();
    } on FirebaseException catch (e) {
      throw Exception("Firestore error: ${e.message}");
    }
  }

  @override
  Future<TeamModel?> getTeamById({required String teamId}) async {
    try {
      final doc = await _teamsCol.doc(teamId).get();
      if (!doc.exists) return null;

      final data = doc.data();
      if (data == null) return null;
      final withId = {
        ...data,
        FirestoreTeamFields.id: doc.id,
      };

      return _jsonMapper.from(withId);
    } on FirebaseException catch (e) {
      throw Exception("Firestore error: ${e.message}");
    } catch (e) {
      throw Exception("Erreur inattendue: $e");
    }
  }

}
