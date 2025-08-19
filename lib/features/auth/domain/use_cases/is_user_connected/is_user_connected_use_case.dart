import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case_without_params.dart';
import 'package:volleyapp/features/auth/domain/repositories/auth_repository.dart';

class IsUserConnectedUseCase implements UseCaseWithoutParams{
  final AuthRepository _authRepository;

  IsUserConnectedUseCase(this._authRepository);

  @override
  Future<Either<Failure, bool>> call() {
    return _authRepository.isUserConnected();
  }
}