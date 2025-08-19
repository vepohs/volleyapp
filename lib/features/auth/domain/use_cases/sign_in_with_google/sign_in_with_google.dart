import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case_without_params.dart';
import 'package:volleyapp/features/auth/domain/entitites/auth_user.dart';
import 'package:volleyapp/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogleUseCase implements UseCaseWithoutParams<AuthUser>{
  final AuthRepository authRepository;

  SignInWithGoogleUseCase(this.authRepository);

  @override
  Future<Either<Failure, AuthUser>> call() {
        return authRepository.signInWithGoogle();
  }

}