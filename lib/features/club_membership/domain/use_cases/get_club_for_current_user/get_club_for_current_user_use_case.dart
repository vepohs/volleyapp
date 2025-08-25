import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case_without_params.dart';
import 'package:volleyapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:volleyapp/features/club/domain/entities/club.dart';
import 'package:volleyapp/features/club/domain/repositories/club_repository.dart';
import 'package:volleyapp/features/club_membership/domain/repositories/club_membership_repository.dart';

class GetClubForCurrentUserUseCase implements UseCaseWithoutParams<Club> {
  final AuthRepository authRepository;
  final ClubMembershipRepository membershipRepository;
  final ClubRepository clubRepository;

  GetClubForCurrentUserUseCase({
    required this.authRepository,
    required this.membershipRepository,
    required this.clubRepository,
  });

  @override
  Future<Either<Failure, Club>> call() async {
    try {
      final authResult = await authRepository.getCurrentUser();
      return await authResult.fold((failure) async => Left(failure), (
        maybeUser,
      ) async {
        return await maybeUser.fold(
          () async => Left(Failure('No current user')),
          (user) async {
            final userId = user.id;
            final membershipResult = await membershipRepository
                .getClubMemberShipByUserId(userId: userId);
            return await membershipResult.fold(
              (failure) async => Left(failure),
              (maybeMembership) async {
                return await maybeMembership.fold(
                  () async => Left(Failure('User has no club membership')),
                  (membership) async {
                    final clubResult = await clubRepository.getClubById(
                      clubId: membership.clubId,
                    );
                    return clubResult;
                  },
                );
              },
            );
          },
        );
      });
    } catch (e) {
      return Left(Failure('GetClubForCurrentUser failed: $e'));
    }
  }
}
