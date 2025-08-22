abstract class CreateTeamFormEvent {}

class TeamNameChanged extends CreateTeamFormEvent {
  final String name;
  TeamNameChanged(this.name);
}

class TeamCategoryChanged extends CreateTeamFormEvent {
  final String category;
  TeamCategoryChanged(this.category);
}

class TeamGenderChanged extends CreateTeamFormEvent {
  final String gender;
  TeamGenderChanged(this.gender);
}

class TeamLevelChanged extends CreateTeamFormEvent {
  final String level;
  TeamLevelChanged(this.level);
}

class TeamAvatarChanged extends CreateTeamFormEvent {
  final String avatarUrl;
  TeamAvatarChanged(this.avatarUrl);
}

class SubmitTeamForm extends CreateTeamFormEvent {}
