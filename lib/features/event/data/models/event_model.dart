class EventModel {
  final String clubId;
  final String id;
  final DateTime startAt;
  final DateTime endAt;
  final String location;

  final String type;

  final Map<String, dynamic> details;

  final DateTime createdAt;

  EventModel({
    required this.clubId,
    required this.id,
    required this.startAt,
    required this.endAt,
    required this.location,
    required this.type,
    required this.details,
    required this.createdAt,
  });
}
