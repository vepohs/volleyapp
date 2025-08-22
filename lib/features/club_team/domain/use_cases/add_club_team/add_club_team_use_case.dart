import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case.dart';
import 'package:volleyapp/features/club_team/domain/entities/club_team.dart';
import 'package:volleyapp/features/club_team/domain/repositories/club_team_repository.dart';
import 'package:volleyapp/features/club_team/domain/use_cases/add_club_team/add_club_team_params.dart';

class AddClubTeamUseCase implements UseCase<ClubTeam, AddClubTeamParams> {
  final ClubTeamRepository repository;

  AddClubTeamUseCase(this.repository);

  @override
  Future<Either<Failure, ClubTeam>> call(AddClubTeamParams params) {
    return repository.addClubTeam(
      clubId: params.clubId,
      teamId: params.teamId,
    );
  }
}
