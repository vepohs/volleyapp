abstract class ClubMembershipException implements Exception {
  final String message;
  const ClubMembershipException(this.message);

  @override
  String toString() => "$runtimeType: $message";
}

class AddClubMembershipException extends ClubMembershipException {
  const AddClubMembershipException(super.message);
}
