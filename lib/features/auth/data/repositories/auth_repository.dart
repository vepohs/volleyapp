import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/auth/data/datasources/auth_datasource.dart';
import 'package:volleyapp/features/auth/data/mappers/auth_user_mapper.dart';
import 'package:volleyapp/features/auth/domain/entitites/auth_user.dart';
import 'package:volleyapp/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _datasource;
  final AuthUserMapper _mapper = AuthUserMapper();

  AuthRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, AuthUser>> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _datasource.signUpWithEmail(
        email: email,
        password: password,
      );
      return Right(_mapper.from(model));
    } catch (e) {
      return Left(Failure('Sign up failed: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isUserConnected() async {
    try {
      final isConnected = await _datasource.isUserConnected();
      return Right(isConnected);
    } catch (e) {
      return Left(Failure('Check connection failed: $e'));
    }
  }

  @override
  Future<Either<Failure, Option<AuthUser>>> getCurrentUser() async {
    try {
      final model = await _datasource.getCurrentUser();
      if (model == null) return Right(None());
      return Right(Some(_mapper.from(model)));
    } catch (e) {
      return Left(Failure('Get current user failed: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _datasource.signInWithEmail(
        email: email,
        password: password,
      );
      return Right(_mapper.from(model));
    } catch (e) {
      return Left(Failure('Sign in failed: $e'));
    }
  }
}

