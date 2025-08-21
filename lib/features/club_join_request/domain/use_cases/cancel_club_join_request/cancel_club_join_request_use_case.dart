import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case.dart';
import 'package:volleyapp/features/club_join_request/domain/entities/club_join_request.dart';
import 'package:volleyapp/features/club_join_request/domain/repositories/club_join_request_repository.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/cancel_club_join_request/cancel_club_join_request_params.dart';

class CancelClubJoinRequestUseCase
    implements UseCase<ClubJoinRequest, CancelClubJoinRequestParams> {
  final ClubJoinRequestRepository repository;

  CancelClubJoinRequestUseCase(this.repository);

  @override
  Future<Either<Failure, ClubJoinRequest>> call(
    CancelClubJoinRequestParams params,
  ) {
   return repository.cancel(requestId: params.requestId);
  }
}
