import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volleyapp/core/constants/firestore_fields.dart';
import 'package:volleyapp/core/mappers/base_mapper.dart';
import 'package:volleyapp/features/event/data/models/event_model.dart';

class EventJsonMapper implements BaseMapper<Map<String, dynamic>, EventModel> {
  @override
  EventModel from(Map<String, dynamic> input) {
    return EventModel(
      id: input[FirestoreEventFields.id] as String,
      startAt: _toDateTime(input[FirestoreEventFields.startAt])!,
      endAt: _toDateTime(input[FirestoreEventFields.endAt])!,
      location: input[FirestoreEventFields.location] as String,
      type: input[FirestoreEventFields.type] as String,
      details: (input[FirestoreEventFields.details] as Map).cast<String, dynamic>(),
      createdAt: _toDateTime(input[FirestoreEventFields.createdAt])!,
    );
  }

  @override
  Map<String, dynamic> to(EventModel output) {
    return {
      FirestoreEventFields.id: output.id,
      FirestoreEventFields.startAt: output.startAt,
      FirestoreEventFields.endAt: output.endAt,
      FirestoreEventFields.location: output.location,
      FirestoreEventFields.type: output.type,
      FirestoreEventFields.details: output.details,
      FirestoreEventFields.createdAt: output.createdAt,
    };
  }

  DateTime? _toDateTime(dynamic v) {
    if (v == null) return null;
    if (v is Timestamp) return v.toDate();
    if (v is String) return DateTime.tryParse(v);
    if (v is DateTime) return v;
    return null;
  }
}
