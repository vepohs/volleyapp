import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case.dart';
import 'package:volleyapp/features/team/domain/entities/team.dart';
import 'package:volleyapp/features/team/domain/repositories/team_repository.dart';
import 'package:volleyapp/features/team/domain/use_cases/get_team_by_id/get_team_by_id_params.dart';

class GetTeamByIdUseCase implements UseCase<Team,GetTeamByIdParams>{
  TeamRepository teamRepository;
  GetTeamByIdUseCase(this.teamRepository);
  @override
  Future<Either<Failure, Team>> call(GetTeamByIdParams params) {
return teamRepository.getAllTeamById(teamId: params.teamId);
  }
}