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
      final snapshot = await _clubsCol.get();

      final lowerQuery = query.toLowerCase();

      return snapshot.docs
          .map((doc) => _jsonMapper.from(doc.data()))
          .where((club) => club.name.toLowerCase().contains(lowerQuery))
          .toList();
    } on FirebaseException catch (e) {
      throw GetClubsFilteredByNameException("Firestore error: ${e.message}");
    } catch (e) {
      throw GetClubsFilteredByNameException("Erreur inattendue: $e");
    }
  }

  @override
  Future<ClubModel?> getClubById({required String clubId}) async {
    try {
      final doc = await _clubsCol.doc(clubId).get();
      if (!doc.exists) return null;

      final data = doc.data();
      if (data == null) return null;

      return _jsonMapper.from({...data, FirestoreClubFields.id: doc.id});
    } on FirebaseException catch (e) {
      throw Exception("Firestore error: ${e.message}");
    }
  }

  @override
  Future<List<ClubModel>> getAllClub() async {
    try {
      final snapshot = await _clubsCol.get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return _jsonMapper.from({
          ...data,
          FirestoreClubFields.id: doc.id,
        });
      }).toList();
    } on FirebaseException catch (e) {
      throw GetAllClubsException("Firestore error: ${e.message}");
    } catch (e) {
      throw GetAllClubsException("Erreur inattendue: $e");
    }
  }

}
