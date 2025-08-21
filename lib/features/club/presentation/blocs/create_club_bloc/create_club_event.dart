abstract class CreateClubEvent {}

class ClubNameChanged extends CreateClubEvent {
  final String clubName;
  ClubNameChanged(this.clubName);
}

class SubmitCreateClub extends CreateClubEvent {}
