import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case.dart';
import 'package:volleyapp/features/club_join_request/domain/entities/club_join_request.dart';
import 'package:volleyapp/features/club_join_request/domain/repositories/club_join_request_repository.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/reject_club_join_request/reject_club_join_request_params.dart';

class RejectClubJoinRequestUseCase
    implements UseCase<ClubJoinRequest, RejectClubJoinRequestParams> {
  final ClubJoinRequestRepository repository;

  RejectClubJoinRequestUseCase(this.repository);

  @override
  Future<Either<Failure, ClubJoinRequest>> call(
    RejectClubJoinRequestParams params,
  ) {
    return repository.reject(requestId: params.requestId);
  }
}
