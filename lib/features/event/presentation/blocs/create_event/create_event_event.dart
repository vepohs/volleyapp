enum CreateEventKind { match, training }

abstract class CreateEventEvent {
  const CreateEventEvent();
}

class EventKindChanged extends CreateEventEvent {
  final CreateEventKind kind;
  const EventKindChanged(this.kind);
}

class StartAtChanged extends CreateEventEvent {
  final DateTime? value;
  const StartAtChanged(this.value);
}

class EndAtChanged extends CreateEventEvent {
  final DateTime? value;
  const EndAtChanged(this.value);
}

class LocationChanged extends CreateEventEvent {
  final String value;
  const LocationChanged(this.value);
}

class HomeClubTeamChanged extends CreateEventEvent {
  final String clubId;
  final String teamId;
  const HomeClubTeamChanged(this.clubId, this.teamId);
}

class AwayClubTeamChanged extends CreateEventEvent {
  final String clubId;
  final String teamId;
  const AwayClubTeamChanged(this.clubId, this.teamId);
}

class TrainingClubTeamChanged extends CreateEventEvent {
  final String clubId;
  final String teamId;
  const TrainingClubTeamChanged(this.clubId, this.teamId);
}

class CompetitionChanged extends CreateEventEvent {
  final String value;
  const CompetitionChanged(this.value);
}

class CoachChanged extends CreateEventEvent {
  final String value;
  const CoachChanged(this.value);
}

class NotesChanged extends CreateEventEvent {
  final String value;
  const NotesChanged(this.value);
}

class CreateEventSubmitted extends CreateEventEvent {}
