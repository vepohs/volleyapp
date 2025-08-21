import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/user/data/datasources/user_datasource.dart';
import 'package:volleyapp/features/user/data/mappers/user_mapper.dart';
import 'package:volleyapp/features/user/domain/entities/user.dart';
import 'package:volleyapp/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDatasource _datasource;
  final UserMapper _mapper = UserMapper();

  UserRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, User>> addUser({
    required String id,
    required String lastname,
    required String firstname,
    required String email,
    required DateTime birthdate,
     String? avatarUrl,
  }) async {
    try {
      final model = await _datasource.addUser(
        id: id,
        firstname: firstname,
        lastname: lastname,
        email: email,
        birthdate: birthdate,
        avatarUrl: avatarUrl,
      );
      return Right(_mapper.from(model));
    } catch (e) {
      return Left(Failure('Add user failed: $e'));
    }
  }

  @override
  Future<Either<Failure, Option<User>>> getUserById({
    required String id,
  }) async {
    try {
      final model = await _datasource.getUserById(id: id);
      if (model == null) return Right(None());
      return Right(Some(_mapper.from(model)));
    } catch (e) {
      return Left(Failure('Get user failed: $e'));
    }
  }
}
