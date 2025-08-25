import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/club_team/domain/entities/club_team.dart';

abstract class ClubTeamRepository {
  Future<Either<Failure, ClubTeam>> addClubTeam({
    required String clubId,
    required String teamId,
  });

  Future<Either<Failure, List<String>>> getAllTeamIdsByClubId({required String clubId});
}
