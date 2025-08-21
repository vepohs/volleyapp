import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/team_membership/domain/entities/team_membership.dart';

abstract class TeamMembershipRepository {
  Future<Either<Failure, TeamMembership>> addTeamMembership({
    required String teamId,
    required String userId,
  });
}
