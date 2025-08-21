
abstract class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => "$runtimeType: $message";
}

class SignUpWithEmailException extends AuthException {
  const SignUpWithEmailException(super.message);
}

class IsUserConnectedException extends AuthException {
  const IsUserConnectedException(super.message);
}
class GetCurrentUserException extends AuthException {
  const GetCurrentUserException(super.message);
}
class SignInWithEmailException extends AuthException {
const SignInWithEmailException(super.message);
}
class SignInWithGoogleException extends AuthException {
  const SignInWithGoogleException(super.message);
}
class SignOutException extends AuthException {
  const SignOutException(super.message);
}
