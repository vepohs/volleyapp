import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/team/domain/entities/team.dart';

abstract class TeamRepository {
  Future<Either<Failure, Team>> addTeam({
    required String name,
    required String category,
    required String gender,
    required String level,
    String? avatarUrl,
  });

  Future<Either<Failure, List<Team>>> getAllTeamByIds(List<String> ids) ;
  Future<Either<Failure, Team>> getAllTeamById({required String teamId});
}
