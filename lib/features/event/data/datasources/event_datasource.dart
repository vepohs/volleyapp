import 'package:volleyapp/features/event/data/models/event_model.dart';

abstract class EventDatasource {
  Future<EventModel> addEvent({
    required DateTime startAt,
    required DateTime endAt,
    required String location,
    required String type,
    required Map<String, dynamic> details,
  });

  Future<EventModel?> getEventById(String id);

  Future<void> updateMatchResult({
    required String eventId,
    required Map<String, dynamic> resultJson,
  });

  Future<List<EventModel>> getAllEvent();
}
