import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case.dart';
import 'package:volleyapp/features/team/domain/entities/team.dart';
import 'package:volleyapp/features/team/domain/repositories/team_repository.dart';
import 'add_team_params.dart';

class AddTeamUseCase implements UseCase<Team, AddTeamParams> {
  final TeamRepository repository;

  AddTeamUseCase(this.repository);

  @override
  Future<Either<Failure, Team>> call(AddTeamParams params) {
    return repository.addTeam(
      name: params.name,
      category: params.category,
      gender: params.gender,
      level: params.level,
      avatarUrl: params.avatarUrl,
    );
  }
}
