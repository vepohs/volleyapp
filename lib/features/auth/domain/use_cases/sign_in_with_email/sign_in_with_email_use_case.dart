import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case.dart';
import 'package:volleyapp/features/auth/domain/entitites/auth_user.dart';
import 'package:volleyapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:volleyapp/features/auth/domain/use_cases/sign_in_with_email/sign_in_with_email_params.dart';

class SignInWithEmailUseCase
    implements UseCase<AuthUser, SignInWithEmailParams> {
  final AuthRepository authRepository;

  SignInWithEmailUseCase(this.authRepository);

  @override
  Future<Either<Failure, AuthUser>> call(params) {
   return authRepository.signInWithEmail( email: params.email,
     password: params.password);
  }
}
