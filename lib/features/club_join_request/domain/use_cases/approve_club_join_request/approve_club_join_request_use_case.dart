import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case.dart';
import 'package:volleyapp/features/club_join_request/domain/entities/club_join_request.dart';
import 'package:volleyapp/features/club_join_request/domain/repositories/club_join_request_repository.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/approve_club_join_request/approve_club_join_request_params.dart';

class ApproveClubJoinRequestUseCase
    implements UseCase<ClubJoinRequest, ApproveClubJoinRequestParams> {
  final ClubJoinRequestRepository repository;

  ApproveClubJoinRequestUseCase(this.repository);

  @override
  Future<Either<Failure, ClubJoinRequest>> call(
      ApproveClubJoinRequestParams params) {
    return repository.approve(requestId: params.requestId);
  }
}