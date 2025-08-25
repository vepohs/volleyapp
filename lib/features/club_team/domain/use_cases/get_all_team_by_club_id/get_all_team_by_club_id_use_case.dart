import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case.dart';
import 'package:volleyapp/features/club_team/domain/repositories/club_team_repository.dart';
import 'package:volleyapp/features/club_team/domain/use_cases/get_all_team_by_club_id/get_all_team_by_club_id_params.dart';
import 'package:volleyapp/features/team/domain/entities/team.dart';
import 'package:volleyapp/features/team/domain/repositories/team_repository.dart';

class GetAllTeamByClubId
    implements UseCase<List<Team>, GetAllTeamByClubIdParams> {
  final ClubTeamRepository clubTeamRepo;
  final TeamRepository teamRepo;

  GetAllTeamByClubId(this.clubTeamRepo, this.teamRepo);

  @override
  Future<Either<Failure, List<Team>>> call(
    GetAllTeamByClubIdParams params,
  ) async {
    final idsOrFail = await clubTeamRepo.getAllTeamIdsByClubId(
      clubId: params.clubId,
    );

    return idsOrFail.fold<Future<Either<Failure, List<Team>>>>(
          (f) async => Left(f),
          (ids) => teamRepo.getAllTeamByIds(ids),
    );


  }
}
