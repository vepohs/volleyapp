class TeamException implements Exception {
  final String message;

  TeamException(this.message);

  @override
  String toString() => "TeamException: $message";
}

class AddTeamException extends TeamException {
  AddTeamException(super.message);
}

class GetTeamsException extends TeamException {
  GetTeamsException(super.message);
}
