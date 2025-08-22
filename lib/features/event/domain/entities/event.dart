import 'package:volleyapp/features/event/domain/entities/event_details.dart';

class Event {
  final String id;
  final DateTime startAt;
  final DateTime endAt;
  final String location;

  final EventDetails details;

  const Event({
    required this.id,
    required this.startAt,
    required this.endAt,
    required this.location,
    required this.details,
  });

  Duration get duration => endAt.difference(startAt);
}