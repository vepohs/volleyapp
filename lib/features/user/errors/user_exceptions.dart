abstract class UserException implements Exception {
  final String message;
  const UserException(this.message);

  @override
  String toString() => "$runtimeType: $message";
}

class AddUserException extends UserException {
  const AddUserException(super.message);
}

class GetUserByIdException extends UserException {
  const GetUserByIdException(super.message);
}

class WatchUserByIdException extends UserException {
  const WatchUserByIdException(super.message);
}
