import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case.dart';
import 'package:volleyapp/features/auth/domain/entitites/auth_user.dart';
import 'package:volleyapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:volleyapp/features/auth/domain/use_cases/sign_up_with_email/sign_up_with_email_params.dart';

class SignUpWithEmailUseCase
    implements UseCase<AuthUser, SignUpWithEmailParams> {
  final AuthRepository authRepository;

  SignUpWithEmailUseCase(this.authRepository);

  @override
  Future<Either<Failure, AuthUser>> call(SignUpWithEmailParams params) {
    return authRepository.signUpWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}
