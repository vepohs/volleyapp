import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case.dart';
import 'package:volleyapp/features/user/domain/entities/user.dart';
import 'package:volleyapp/features/user/domain/repositories/user_repository.dart';
import 'package:volleyapp/features/user/domain/use_cases/add_user/add_user_params.dart';

class AddUserUseCase implements UseCase<User, AddUserParams> {
  final UserRepository repository;

  AddUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(AddUserParams params) {
    return repository.addUser(
      id: params.id,
      lastname: params.lastname,
      firstname: params.firstname,
      email: params.email,
      birthdate: params.birthdate,
      avatarUrl: params.avatarUrl,
    );
  }
}
