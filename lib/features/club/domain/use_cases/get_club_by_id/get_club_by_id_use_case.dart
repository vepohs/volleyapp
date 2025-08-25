import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case.dart';
import 'package:volleyapp/features/club/domain/entities/club.dart';
import 'package:volleyapp/features/club/domain/repositories/club_repository.dart';
import 'package:volleyapp/features/club/domain/use_cases/get_club_by_id/get_club_by_id_params.dart';

class GetClubByIdUseCase implements UseCase<Club, GetClubByIdParams> {
  ClubRepository clubRepository;

  GetClubByIdUseCase(this.clubRepository);

  @override
  Future<Either<Failure, Club>> call(GetClubByIdParams params) {
    return clubRepository.getClubById(clubId: params.clubId);
  }
}
