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

  @override
  Future<Either<Failure, Option<ClubMembership>>> getClubByUserId({
    required String userId,
  }) async {
    try {
      final model = await datasource.getClubByUserId(userId: userId);

      if (model == null) {
        return const Right(None());
      }
      return Right(Some(mapper.from(model)));
    } catch (e) {
      return Left(Failure("Erreur lors de la récupération du membership: $e"));
    }
  }

  @override
  Stream<Option<ClubMembership>> watchClubByUserId({
    required String userId,
  }) async* {
    try {
      await for (final model in datasource.watchClubByUserId(userId: userId)) {
        if (model == null) {
          yield const None();
        } else {
          yield Some(mapper.from(model));
        }
      }
    } catch (e) {
      yield const None();
    }
  }
}
