import 'package:dartz/dartz.dart';
import 'package:volleyapp/features/auth/domain/entitites/auth_user.dart';

abstract class AuthStateSource {
  Stream<AuthUser?> get changes;
  Option<AuthUser> getCurrentUser();
}