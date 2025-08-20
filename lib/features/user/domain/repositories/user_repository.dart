import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/user/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> addUser({
    required String id,
    required String lastname,
    required String firstname,
    required String email,
    required DateTime birthdate,
     String? avatarUrl,
  });

  Future<Either<Failure, Option<User>>> getUserById({required String id});
}
