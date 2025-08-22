import 'package:volleyapp/features/event/domain/entities/event_details.dart';
import 'package:volleyapp/features/event/domain/entities/result.dart';

class MatchDetails extends EventDetails {
  final String homeClubId;
  final String homeTeamId;
  final String awayClubId;
  final String awayTeamId;
  final Result? result;

  final String? competition;

  const MatchDetails({
    required this.homeClubId,
    required this.homeTeamId,
    required this.awayClubId,
    required this.awayTeamId,
    this.result,
    this.competition,
  });
}
