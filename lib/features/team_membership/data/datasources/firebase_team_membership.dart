import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volleyapp/core/constants/firestore_collections.dart';
import 'package:volleyapp/features/team_membership/data/datasources/team_membership_datasource.dart';
import 'package:volleyapp/features/team_membership/data/models/team_membership_model.dart';
import 'package:volleyapp/features/team_membership/data/mappers/team_membership_json_mapper.dart';
import 'package:volleyapp/features/team_membership/errors/team_membership_exception.dart';

class FirebaseTeamMembershipDatasource implements TeamMembershipDataSource {
  final FirebaseFirestore firestore;
  final TeamMembershipJsonMapper _jsonMapper = TeamMembershipJsonMapper();

  FirebaseTeamMembershipDatasource({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _membershipsCol =>
      firestore.collection(FirestoreCollections.teamMemberships);

  @override
  Future<TeamMembershipModel> addTeamMembership({
    required String teamId,
    required String userId,
  }) async {
    try {
      final docRef = _membershipsCol.doc();
      final generatedId = docRef.id;

      final membership = TeamMembershipModel(
        id: generatedId,
        teamId: teamId,
        userId: userId,
        joinedAt: DateTime.now(),
      );

      await docRef.set(_jsonMapper.to(membership));

      return membership;
    } on FirebaseException catch (e) {
      throw AddTeamMembershipException("Firestore error: ${e.message}");
    } catch (e) {
      throw AddTeamMembershipException("Erreur inattendue: $e");
    }
  }
}
