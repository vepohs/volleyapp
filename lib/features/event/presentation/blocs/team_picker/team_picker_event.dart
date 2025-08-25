abstract class TeamPickerEvent  {
  const TeamPickerEvent();
}
class TeamPickerLoadForClub extends TeamPickerEvent {
  final String clubId;
  const TeamPickerLoadForClub(this.clubId);
}


class TeamSelected extends TeamPickerEvent {
  final String teamId;
  const TeamSelected(this.teamId);
}