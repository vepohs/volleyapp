import 'package:volleyapp/features/event/domain/entities/event_details.dart';

class AddEventParams {
  final DateTime startAt;
  final DateTime endAt;
  final String location;
  final EventDetails details;

  AddEventParams({
    required this.startAt,
    required this.endAt,
    required this.location,
    required this.details,
  });
}
