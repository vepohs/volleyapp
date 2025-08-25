import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volleyapp/core/constants/firestore_collections.dart';
import 'package:volleyapp/core/constants/firestore_fields.dart';
import 'package:volleyapp/features/club_join_request/data/datasources/club_join_request_datasource.dart';
import 'package:volleyapp/features/club_join_request/data/mappers/club_join_request_json_mapper.dart';
import 'package:volleyapp/features/club_join_request/data/models/club_join_request_model.dart';
import 'package:volleyapp/features/club_join_request/errors/club_join_request_exception.dart';

class FirebaseClubRequestDataSource implements ClubRequestDataSource {
  final FirebaseFirestore firestore;
  final ClubJoinRequestJsonMapper _mapper = ClubJoinRequestJsonMapper();

  FirebaseClubRequestDataSource({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _requestsCol =>
      firestore.collection(FirestoreCollections.clubJoinRequests);

  @override
  Future<ClubJoinRequestModel> submit({
    required String clubId,
    required String userId,
  }) async {
    try {
      final existing = await _requestsCol
          .where(FirestoreClubJoinRequestFields.clubId, isEqualTo: clubId)
          .where(FirestoreClubJoinRequestFields.userId, isEqualTo: userId)
          .where(FirestoreClubJoinRequestFields.status, isEqualTo: 'pending')
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        throw const DuplicatePendingRequestException(
          "Une demande en attente existe déjà pour ce club et cet utilisateur.",
        );
      }

      final docRef = _requestsCol.doc();
      final now = DateTime.now();

      final model = ClubJoinRequestModel(
        id: docRef.id,
        clubId: clubId,
        userId: userId,
        status: 'pending',
        createdAt: now,
        decidedAt: null,
      );

      await docRef.set(_mapper.to(model));
      return model;
    } on ClubRequestException {
      rethrow;
    } on FirebaseException catch (e) {
      throw SubmitClubJoinRequestException("Firestore error: ${e.message}");
    } catch (e) {
      throw SubmitClubJoinRequestException("Erreur inattendue: $e");
    }
  }

  @override
  Future<ClubJoinRequestModel> approve({required String requestId}) async {
    try {
      final ref = _requestsCol.doc(requestId);
      final snap = await ref.get();
      if (!snap.exists) {
        throw ApproveClubJoinRequestException("Demande introuvable.");
      }
      final data = snap.data()!;
      if (data[FirestoreClubJoinRequestFields.status] != 'pending') {
        throw ApproveClubJoinRequestException(
          "La demande n'est pas 'pending'.",
        );
      }

      final updated = {
        ...data,
        FirestoreClubJoinRequestFields.status: 'approved',
        FirestoreClubJoinRequestFields.decidedAt: DateTime.now()
            .toIso8601String(),
      };
      await ref.update(updated);
      return _mapper.from(updated);
    } on FirebaseException catch (e) {
      throw ApproveClubJoinRequestException("Firestore error: ${e.message}");
    } catch (e) {
      throw ApproveClubJoinRequestException("Erreur inattendue: $e");
    }
  }

  @override
  Future<ClubJoinRequestModel> reject({required String requestId}) async {
    try {
      final ref = _requestsCol.doc(requestId);
      final snap = await ref.get();
      if (!snap.exists) {
        throw RejectClubJoinRequestException("Demande introuvable.");
      }
      final data = snap.data()!;
      if (data[FirestoreClubJoinRequestFields.status] != 'pending') {
        throw RejectClubJoinRequestException("La demande n'est pas 'pending'.");
      }

      final updated = {
        ...data,
        FirestoreClubJoinRequestFields.status: 'rejected',
        FirestoreClubJoinRequestFields.decidedAt: DateTime.now()
            .toIso8601String(),
      };
      await ref.update(updated);
      return _mapper.from(updated);
    } on FirebaseException catch (e) {
      throw RejectClubJoinRequestException("Firestore error: ${e.message}");
    } catch (e) {
      throw RejectClubJoinRequestException("Erreur inattendue: $e");
    }
  }

  @override
  Future<ClubJoinRequestModel> cancel({required String requestId}) async {
    try {
      final ref = _requestsCol.doc(requestId);
      final snap = await ref.get();

      if (!snap.exists) {
        throw CancelClubJoinRequestException("Demande introuvable.");
      }

      final data = snap.data()!;
      if (data[FirestoreClubJoinRequestFields.status] != 'pending') {
        throw CancelClubJoinRequestException(
          "Seules les demandes 'pending' peuvent être annulées.",
        );
      }

      final updated = {
        ...data,
        FirestoreClubJoinRequestFields.status: 'canceled',
        FirestoreClubJoinRequestFields.decidedAt: DateTime.now()
            .toIso8601String(),
      };

      await ref.update(updated);
      return _mapper.from(updated);
    } on FirebaseException catch (e) {
      throw CancelClubJoinRequestException("Firestore error: ${e.message}");
    } catch (e) {
      throw CancelClubJoinRequestException("Erreur inattendue: $e");
    }
  }

  @override
  Future<List<ClubJoinRequestModel>> getAllClubJoinRequestByClubId({
    required String clubId,
  }) async {
    try {
      final qs = await _requestsCol
          .where(FirestoreClubJoinRequestFields.clubId, isEqualTo: clubId)
          .where(FirestoreClubJoinRequestFields.status, isEqualTo: 'pending')
          .get();

      return qs.docs.map((doc) {
        final data = doc.data();
        return _mapper.from({
          ...data,
          FirestoreClubJoinRequestFields.id: doc.id,
        });
      }).toList();
    } on FirebaseException catch (e) {
      throw GetAllClubJoinRequestException('Firestore error: ${e.message}');
    } catch (e) {
      throw GetAllClubJoinRequestException('Erreur inattendue: $e');
    }
  }
}
