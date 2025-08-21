
import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case.dart';
import 'package:volleyapp/features/club_membership/domain/entities/club_membership.dart';
import 'package:volleyapp/features/club_membership/domain/repositories/club_membership_repository.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/add_club_membership_use_case/add_club_memership_params.dart';

class AddClubMembershipUseCase implements UseCase<ClubMembership, AddClubMembershipParams> {
  final ClubMembershipRepository repository;

  AddClubMembershipUseCase(this.repository);

  @override
  Future<Either<Failure, ClubMembership>> call(AddClubMembershipParams params) {
    return repository.addClubMembership(
      clubId: params.clubId,
      userId: params.userId,
      role: params.role,
    );
  }
}
