abstract class TeamEvent {}

class LoadTeamsByClubId extends TeamEvent {
  final String clubId;

  LoadTeamsByClubId({required this.clubId});
}
