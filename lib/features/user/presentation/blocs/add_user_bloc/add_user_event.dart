abstract class AddUserEvent {}

class FirstnameChanged extends AddUserEvent {
  final String firstname;
  FirstnameChanged(this.firstname);
}

class LastnameChanged extends AddUserEvent {
  final String lastname;
  LastnameChanged(this.lastname);
}

class BirthdateChanged extends AddUserEvent {
  final DateTime birthdate;
  BirthdateChanged(this.birthdate);
}

class AvatarChanged extends AddUserEvent {
  final String avatarUrl;
  AvatarChanged(this.avatarUrl);
}

class SubmitAddUser extends AddUserEvent {}
