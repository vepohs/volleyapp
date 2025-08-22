class EventModel {
  final String id;
  final DateTime startAt;
  final DateTime endAt;
  final String location;

  /// "match" | "training"
  final String type;

  /// JSON des détails
  final Map<String, dynamic> details;

  /// date de création serveur/app
  final DateTime createdAt;

  EventModel({
    required this.id,
    required this.startAt,
    required this.endAt,
    required this.location,
    required this.type,
    required this.details,
    required this.createdAt,
  });
}
