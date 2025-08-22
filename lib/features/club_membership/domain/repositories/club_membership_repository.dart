import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/club_membership/domain/entities/club_membership.dart';
import 'package:volleyapp/features/club_membership/domain/entities/role.dart';

abstract class ClubMembershipRepository {
  Future<Either<Failure, ClubMembership>> addClubMembership({
    required String clubId,
    required String userId,
    required Role role,
  });

  Future<Either<Failure, Option<ClubMembership>>> getClubByUserId({
    required String userId,
  });

  Stream<Option<ClubMembership>> watchClubByUserId({
    required String userId,
  });
}
