import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/club_membership/data/datasources/club_membership_datasource.dart';
import 'package:volleyapp/features/club_membership/data/mappers/club_membership_mapper.dart';
import 'package:volleyapp/features/club_membership/domain/entities/club_membership.dart';
import 'package:volleyapp/features/club_membership/domain/entities/role.dart';
import 'package:volleyapp/features/club_membership/domain/repositories/club_membership_repository.dart';

class ClubMembershipRepositoryImpl implements ClubMembershipRepository {
  final ClubMembershipDataSource datasource;
  final ClubMembershipMapper mapper = ClubMembershipMapper();

  ClubMembershipRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, ClubMembership>> addClubMembership({
    required String clubId,
    required String userId,
    required Role role,
  }) async {
    try {
      final model = await datasource.addClubMembership(
        clubId: clubId,
        userId: userId,
        roleId: role.id,
      );

      return Right(mapper.from(model));
    } catch (e) {
      return Left(Failure("Erreur lors de l’ajout du membership: $e"));
    }
  }
}
