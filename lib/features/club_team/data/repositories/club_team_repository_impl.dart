import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/club_team/data/datasources/club_team_datasource.dart';
import 'package:volleyapp/features/club_team/data/mappers/club_team_mapper.dart';
import 'package:volleyapp/features/club_team/domain/entities/club_team.dart';
import 'package:volleyapp/features/club_team/domain/repositories/club_team_repository.dart';

class ClubTeamRepositoryImpl implements ClubTeamRepository {
  final ClubTeamDataSource datasource;
  final ClubTeamMapper mapper = ClubTeamMapper();

  ClubTeamRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, ClubTeam>> addClubTeam({
    required String clubId,
    required String teamId,
  }) async {
    try {
      final model = await datasource.addClubTeam(
        clubId: clubId,
        teamId: teamId,
      );

      return Right(mapper.from(model));
    } catch (e) {
      return Left(Failure("Erreur lors de l’ajout du club-team: $e"));
    }
  }
}
