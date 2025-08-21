abstract class TeamMembershipException implements Exception {
  final String message;
  const TeamMembershipException(this.message);

  @override
  String toString() => "$runtimeType: $message";
}

class AddTeamMembershipException extends TeamMembershipException {
  const AddTeamMembershipException(super.message);
}

class GetTeamMembershipsException extends TeamMembershipException {
  const GetTeamMembershipsException(super.message);
}

class RemoveTeamMembershipException extends TeamMembershipException {
  const RemoveTeamMembershipException(super.message);
}
