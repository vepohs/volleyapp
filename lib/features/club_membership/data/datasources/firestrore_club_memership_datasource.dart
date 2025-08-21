import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volleyapp/core/constants/firestore_collections.dart';
import 'package:volleyapp/features/club_membership/data/datasources/club_membership_datasource.dart';
import 'package:volleyapp/features/club_membership/data/models/club_membership_model.dart';
import 'package:volleyapp/features/club_membership/errors/club_membership_exception.dart';

import '../mappers/club_membership_json_mapper.dart';

class FirebaseClubMembershipDatasource implements ClubMembershipDataSource {
  final FirebaseFirestore firestore;
  final ClubMembershipJsonMapper _jsonMapper = ClubMembershipJsonMapper();

  FirebaseClubMembershipDatasource({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _membershipsCol =>
      firestore.collection(FirestoreCollections.clubMemberships);

  @override
  Future<ClubMembershipModel> addClubMembership({
    required String clubId,
    required String userId,
    required String roleId,
  }) async {
    try {
      final docRef = _membershipsCol.doc();
      final generatedId = docRef.id;

      final membership = ClubMembershipModel(
        id: generatedId,
        clubId: clubId,
        userId: userId,
        roleId: roleId,
        joinedAt: DateTime.now(),
      );

      await docRef.set(_jsonMapper.to(membership));

      return membership;
    } on FirebaseException catch (e) {
      throw AddClubMembershipException("Firestore error: ${e.message}");
    } catch (e) {
      throw AddClubMembershipException("Erreur inattendue: $e");
    }
  }
}
