import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/club_join_request/domain/entities/club_join_request.dart';

abstract class ClubJoinRequestRepository {
  Future<Either<Failure, ClubJoinRequest>> submit({
    required String clubId,
    required String userId,
  });

  Future<Either<Failure, ClubJoinRequest>> approve({required String requestId});

  Future<Either<Failure, ClubJoinRequest>> reject({required String requestId});

  Future<Either<Failure, ClubJoinRequest>> cancel({required String requestId});

  Future<Either<Failure, List<ClubJoinRequest>>> getAllClubJoinRequest();
}
