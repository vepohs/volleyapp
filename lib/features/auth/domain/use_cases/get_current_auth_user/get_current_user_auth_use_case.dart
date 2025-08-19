import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case_without_params_optional.dart';
import 'package:volleyapp/features/auth/domain/entitites/auth_user.dart';
import 'package:volleyapp/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserAuthUseCase implements UseCaseWithoutParamsOptional<AuthUser> {
  final AuthRepository _authRepository;

  GetCurrentUserAuthUseCase(this._authRepository);

  @override
  Future<Either<Failure, Option<AuthUser>>> call() {
  return  _authRepository.getCurrentUser();
  }
}