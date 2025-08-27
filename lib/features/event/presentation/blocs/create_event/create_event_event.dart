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

class HomeClubChanged extends CreateEventEvent {
  final String clubId;
  const HomeClubChanged(this.clubId);
}

class HomeTeamChanged extends CreateEventEvent {
  final String teamId;
  const HomeTeamChanged(this.teamId);
}

class AwayClubChanged extends CreateEventEvent {
  final String clubId;
  const AwayClubChanged(this.clubId);
}

class AwayTeamChanged extends CreateEventEvent {
  final String teamId;
  const AwayTeamChanged(this.teamId);
}

class TrainingClubChanged extends CreateEventEvent {
  final String clubId;
  const TrainingClubChanged(this.clubId);
}

class TrainingTeamChanged extends CreateEventEvent {
  final String teamId;
  const TrainingTeamChanged(this.teamId);
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

class CreateEventSubmitted extends CreateEventEvent {
  const CreateEventSubmitted();
}
