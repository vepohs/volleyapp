import 'package:volleyapp/features/event/domain/entities/event_details.dart';

class AddEventParams {
  final String clubId;
  final DateTime startAt;
  final DateTime endAt;
  final String location;
  final EventDetails details;

  AddEventParams({
    required this.clubId,
    required this.startAt,
    required this.endAt,
    required this.location,
    required this.details,
  });
}
