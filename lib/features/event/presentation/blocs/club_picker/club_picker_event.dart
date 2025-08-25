
abstract class ClubPickerEvent  {
  const ClubPickerEvent();

}

class ClubPickerStarted extends ClubPickerEvent {}

class ClubSelected extends ClubPickerEvent {
  final String clubId;
  const ClubSelected(this.clubId);
}
