import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case_without_params.dart';
import 'package:volleyapp/features/club/domain/entities/club.dart';
import 'package:volleyapp/features/club/domain/repositories/club_repository.dart';

class GetAllClubUseCase implements UseCaseWithoutParams<List<Club>> {
  ClubRepository clubRepository;

  GetAllClubUseCase(this.clubRepository);

  @override
  Future<Either<Failure, List<Club>>> call() {
    return clubRepository.getAllClub();
  }
}
