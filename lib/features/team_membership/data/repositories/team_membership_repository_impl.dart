import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/team_membership/data/datasources/team_membership_datasource.dart';
import 'package:volleyapp/features/team_membership/data/mappers/team_membership_mapper.dart';
import 'package:volleyapp/features/team_membership/domain/entities/team_membership.dart';
import 'package:volleyapp/features/team_membership/domain/repositories/team_membership_repository.dart';

class TeamMembershipRepositoryImpl implements TeamMembershipRepository {
  final TeamMembershipDataSource _dataSource;
  final TeamMembershipMapper _mapper = TeamMembershipMapper();

  TeamMembershipRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, TeamMembership>> addTeamMembership({
    required String teamId,
    required String userId,
  }) async {
    try {
      final model = await _dataSource.addTeamMembership(
        teamId: teamId,
        userId: userId,
      );

      final entity = _mapper.from(model);

      return Right(entity);
    } catch (e) {
      return Left(Failure('Add team membership failed: $e'));
    }
  }
}
