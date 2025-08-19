
import 'package:volleyapp/features/auth/domain/entitites/auth_user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class Authenticated extends AuthState {
  final AuthUser authUser;
  Authenticated(this.authUser);
}


class Unauthenticated extends AuthState {}
