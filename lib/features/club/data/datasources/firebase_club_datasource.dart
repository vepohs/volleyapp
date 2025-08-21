import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volleyapp/core/constants/firestore_collections.dart';
import 'package:volleyapp/core/constants/firestore_fields.dart';
import 'package:volleyapp/features/club/data/datasources/club_datasource.dart';
import 'package:volleyapp/features/club/data/mappers/club_json_mapper.dart';
import 'package:volleyapp/features/club/data/models/club_model.dart';
import 'package:volleyapp/features/club/errors/club_exception.dart';

class FirebaseClubDatasource implements ClubDataSource {
  final FirebaseFirestore firestore;
  final ClubJsonMapper _jsonMapper = ClubJsonMapper();

  FirebaseClubDatasource({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _clubsCol =>
      firestore.collection(FirestoreCollections.clubs);

  @override
  Future<ClubModel> addClub({required String name, String? avatarUrl}) async {
    try {
      final docRef = _clubsCol.doc();
      final generatedId = docRef.id;

      final club = ClubModel(
        id: generatedId,
        name: name,
        avatarUrl: avatarUrl ?? '',
      );

      await docRef.set(_jsonMapper.to(club));
      return club;
    } on FirebaseException catch (e) {
      throw AddClubException("Firestore error: ${e.message}");
    } catch (e) {
      throw AddClubException("Erreur inattendue: $e");
    }
  }

  @override
  Future<List<ClubModel>> getClubsFilteredByName(String query) async {
    try {
      final snapshot = await _clubsCol
          .orderBy(FirestoreClubFields.name)
          .startAt([query])
          .endAt(["$query\uf8ff"])
          .get();

      return snapshot.docs.map((doc) => _jsonMapper.from(doc.data())).toList();
    } on FirebaseException catch (e) {
      throw GetClubsFilteredByNameException("Firestore error: ${e.message}");
    } catch (e) {
      throw GetClubsFilteredByNameException("Erreur inattendue: $e");
    }
  }
}
