import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case_without_params.dart';
import 'package:volleyapp/features/club_join_request/domain/entities/club_join_request.dart';
import 'package:volleyapp/features/club_join_request/domain/repositories/club_join_request_repository.dart';

class GetAllClubJoinRequestUseCase extends UseCaseWithoutParams<List<ClubJoinRequest>> {
  final ClubJoinRequestRepository repository;

  GetAllClubJoinRequestUseCase(this.repository);

  @override
  Future<Either<Failure, List<ClubJoinRequest>>> call() {
    return repository.getAllClubJoinRequest();
  }
}
