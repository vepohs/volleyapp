import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case.dart';
import 'package:volleyapp/features/club_join_request/domain/entities/club_join_request.dart';
import 'package:volleyapp/features/club_join_request/domain/repositories/club_join_request_repository.dart';
import 'submit_club_join_request_params.dart';

class SubmitClubJoinRequestUseCase
    implements UseCase<ClubJoinRequest, SubmitClubJoinRequestParams> {
  final ClubJoinRequestRepository repository;
  SubmitClubJoinRequestUseCase(this.repository);

  @override
  Future<Either<Failure, ClubJoinRequest>> call(SubmitClubJoinRequestParams params) {
    return repository.submit(clubId: params.clubId, userId: params.userId);
  }
}
