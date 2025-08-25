import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case.dart';
import 'package:volleyapp/features/club_join_request/domain/entities/club_join_request.dart';
import 'package:volleyapp/features/club_join_request/domain/repositories/club_join_request_repository.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/get_all_club_join_request_by_club_id/get_all_club_join_request_by_club_id_params.dart';

class GetAllClubJoinRequestUseCase
    extends
        UseCase<List<ClubJoinRequest>, GetAllClubJoinRequestByClubIdParams> {
  final ClubJoinRequestRepository repository;

  GetAllClubJoinRequestUseCase(this.repository);

  @override
  Future<Either<Failure, List<ClubJoinRequest>>> call(
    GetAllClubJoinRequestByClubIdParams params,
  ) {
    return repository.getAllClubJoinRequestByClubId(clubId: params.clubId);
  }
}
