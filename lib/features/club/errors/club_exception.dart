abstract class ClubException implements Exception {
  final String message;

  const ClubException(this.message);

  @override
  String toString() => "$runtimeType: $message";
}

class AddClubException extends ClubException {
  const AddClubException(super.message);
}

class GetClubByIdException extends ClubException {
  const GetClubByIdException(super.message);
}

class WatchClubByIdException extends ClubException {
  const WatchClubByIdException(super.message);
}

class GetClubsFilteredByNameException extends ClubException {
  const GetClubsFilteredByNameException(super.message);
}
