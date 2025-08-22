import 'package:volleyapp/core/constants/firestore_fields.dart';
import 'package:volleyapp/core/mappers/base_mapper.dart';
import 'package:volleyapp/features/event/data/models/event_model.dart';
import 'package:volleyapp/features/event/domain/entities/event.dart';
import 'package:volleyapp/features/event/domain/entities/event_details.dart';
import 'package:volleyapp/features/event/domain/entities/match_details.dart';
import 'package:volleyapp/features/event/domain/entities/training_details.dart';
import 'package:volleyapp/features/event/data/mappers/result_json_mapper.dart';

class EventMapper implements BaseMapper<EventModel, Event> {
  final ResultJsonMapper _result = ResultJsonMapper();

  @override
  Event from(EventModel input) {
    final detailsMap = input.details;
    final EventDetails details;

    switch (input.type) {
      case 'match':
        details = MatchDetails(
          homeClubId: detailsMap[FirestoreEventFields.homeClubId] as String,
          homeTeamId: detailsMap[FirestoreEventFields.homeTeamId] as String,
          awayClubId: detailsMap[FirestoreEventFields.awayClubId] as String,
          awayTeamId: detailsMap[FirestoreEventFields.awayTeamId] as String,
          competition: detailsMap[FirestoreEventFields.competition] as String?,
          result: _result.from(detailsMap[FirestoreEventFields.result] as Map<String, dynamic>?),
        );
        break;
      case 'training':
        details = TrainingDetails(
          clubId: detailsMap[FirestoreEventFields.clubId] as String,
          teamId: detailsMap[FirestoreEventFields.teamId] as String,
          coachId: detailsMap[FirestoreEventFields.coachId] as String?,
          notes: detailsMap[FirestoreEventFields.notes] as String?,
        );
        break;
      default:
        throw UnsupportedError('Unknown event type: ${input.type}');
    }

    return Event(
      id: input.id,
      startAt: input.startAt,
      endAt: input.endAt,
      location: input.location,
      details: details,
    );
  }

  @override
  EventModel to(Event output) {
    final String type = typeFromDetails(output.details);
    final Map<String, dynamic> details = detailsToJson(output.details);

    return EventModel(
      id: output.id,
      startAt: output.startAt,
      endAt: output.endAt,
      location: output.location,
      type: type,
      details: details..removeWhere((k, v) => v == null),
      createdAt: DateTime.now(),
    );
  }

  /// ---- Helpers utilisés par le RepositoryImpl ----

  String typeFromDetails(EventDetails details) {
    if (details is MatchDetails) return 'match';
    if (details is TrainingDetails) return 'training';
    throw UnsupportedError('Unsupported EventDetails: ${details.runtimeType}');
  }

  Map<String, dynamic> detailsToJson(EventDetails details) {
    if (details is MatchDetails) {
      return {
        FirestoreEventFields.homeClubId: details.homeClubId,
        FirestoreEventFields.homeTeamId: details.homeTeamId,
        FirestoreEventFields.awayClubId: details.awayClubId,
        FirestoreEventFields.awayTeamId: details.awayTeamId,
        FirestoreEventFields.competition: details.competition,
        if (details.result != null)
          FirestoreEventFields.result: _result.to(details.result!),
      };
    }
    if (details is TrainingDetails) {
      return {
        FirestoreEventFields.clubId: details.clubId,
        FirestoreEventFields.teamId: details.teamId,
        FirestoreEventFields.coachId: details.coachId,
        FirestoreEventFields.notes: details.notes,
      };
    }
    throw UnsupportedError('Unsupported EventDetails: ${details.runtimeType}');
  }
}
