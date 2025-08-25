import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volleyapp/core/constants/firestore_collections.dart';
import 'package:volleyapp/core/constants/firestore_fields.dart';
import 'package:volleyapp/features/event/data/datasources/event_datasource.dart';
import 'package:volleyapp/features/event/data/mappers/event_json_mapper.dart';
import 'package:volleyapp/features/event/data/models/event_model.dart';
import 'package:volleyapp/features/event/errors/event_exception.dart';

class FirebaseEventDatasource implements EventDatasource {
  final FirebaseFirestore firestore;
  final EventJsonMapper _mapper = EventJsonMapper();

  FirebaseEventDatasource({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _col =>
      firestore.collection(FirestoreCollections.events);

  @override
  Future<EventModel> addEvent({
    required String clubId,
    required DateTime startAt,
    required DateTime endAt,
    required String location,
    required String type,
    required Map<String, dynamic> details,
  }) async {
    try {
      final docRef = _col.doc();
      final model = EventModel(
        id: docRef.id,
        clubId: clubId,
        startAt: startAt,
        endAt: endAt,
        location: location,
        type: type,
        details: details,
        createdAt: DateTime.now(),
      );
      await docRef.set(_mapper.to(model));
      return model;
    } on FirebaseException catch (e) {
      throw AddEventException('Firestore error: ${e.message}');
    } catch (e) {
      throw AddEventException('Erreur inattendue: $e');
    }
  }

  @override
  Future<EventModel?> getEventById(String id) async {
    try {
      final snap = await _col.doc(id).get();
      if (!snap.exists) return null;
      final data = snap.data();
      if (data == null) return null;
      return _mapper.from({...data, FirestoreEventFields.id: id});
    } on FirebaseException catch (e) {
      throw GetEventByIdException('Firestore error: ${e.message}');
    } catch (e) {
      throw GetEventByIdException('Erreur inattendue: $e');
    }
  }

  @override
  Future<void> updateMatchResult({
    required String eventId,
    required Map<String, dynamic> resultJson,
  }) async {
    try {
      final ref = _col.doc(eventId);
      final snap = await ref.get();
      if (!snap.exists) {
        throw UpdateMatchResultException('Event $eventId introuvable');
      }
      final data = snap.data()!;
      final type = data[FirestoreEventFields.type] as String?;
      if (type != 'match') {
        throw UpdateMatchResultException('Event $eventId n\'est pas un match');
      }

      await ref.update({
        '${FirestoreEventFields.details}.${FirestoreEventFields.result}':
            resultJson,
      });
    } on FirebaseException catch (e) {
      throw UpdateMatchResultException('Firestore error: ${e.message}');
    } catch (e) {
      throw UpdateMatchResultException('Erreur inattendue: $e');
    }
  }

  @override
  Future<List<EventModel>> getAllEventByClubId({required String clubId}) async {
    try {
      final snap = await _col
          .where(FirestoreEventFields.clubId, isEqualTo: clubId)
          .get();

      return snap.docs.map((doc) {
        final data = doc.data();
        final withId = <String, dynamic>{
          ...data,
          FirestoreEventFields.id: doc.id,
        };
        return _mapper.from(withId);
      }).toList();
    } on FirebaseException catch (e) {
      throw GetAllEventsException('Firestore error: ${e.message}');
    } catch (e) {
      throw GetAllEventsException('Erreur inattendue: $e');
    }
  }
}
