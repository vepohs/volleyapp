import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case_optional.dart';
import 'package:volleyapp/features/club_membership/domain/entities/club_membership.dart';
import 'package:volleyapp/features/club_membership/domain/repositories/club_membership_repository.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/get_club_by%20_user_id/get_club_by_user_id_params.dart';

class GetClubUserIdUseCase
    implements UseCaseOptional<ClubMembership, GetClubByUserIdParams> {
  final ClubMembershipRepository repository;

  GetClubUserIdUseCase(this.repository);

  @override
  Future<Either<Failure, Option<ClubMembership>>> call(
    GetClubByUserIdParams params,
  ) {
    return repository.getClubByUserId(userId: params.userId);
  }
}
