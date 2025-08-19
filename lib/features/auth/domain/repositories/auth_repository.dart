import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/auth/domain/entitites/auth_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUser>> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, bool>> isUserConnected();

  Future<Either<Failure, Option<AuthUser>>> getCurrentUser();

  Future<Either<Failure, AuthUser>> signInWithEmail({required String email, required String password});

  Future<Either<Failure, AuthUser>> signInWithGoogle();
}
