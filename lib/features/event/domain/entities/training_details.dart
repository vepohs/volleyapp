import 'package:volleyapp/features/event/domain/entities/event_details.dart';

class TrainingDetails extends EventDetails {
  final String clubId;
  final String teamId;
  final String? coachId;
  final String? notes;

  const TrainingDetails({
    required this.clubId,
    required this.teamId,
    this.coachId,
    this.notes,
  });
}
