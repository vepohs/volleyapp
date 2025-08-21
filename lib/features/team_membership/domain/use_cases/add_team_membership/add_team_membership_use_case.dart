import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case.dart';
import 'package:volleyapp/features/team_membership/domain/entities/team_membership.dart';
import 'package:volleyapp/features/team_membership/domain/repositories/team_membership_repository.dart';
import 'add_team_membership_params.dart';

class AddTeamMembershipUseCase
    implements UseCase<TeamMembership, AddTeamMembershipParams> {
  final TeamMembershipRepository repository;

  AddTeamMembershipUseCase(this.repository);

  @override
  Future<Either<Failure, TeamMembership>> call(AddTeamMembershipParams params) {
    return repository.addTeamMembership(
      teamId: params.teamId,
      userId: params.userId,
    );
  }
}
