import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case_without_params.dart';
import 'package:volleyapp/features/auth/domain/repositories/auth_repository.dart';

class SignOutUseCase implements UseCaseWithoutParams {
  final AuthRepository authRepository;

  SignOutUseCase(this.authRepository);

  @override
  Future<Either<Failure, Unit>> call() {
    return authRepository.signOut();
  }
}
