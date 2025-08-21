import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case.dart';
import 'package:volleyapp/features/club/domain/entities/club.dart';
import 'package:volleyapp/features/club/domain/repositories/club_repository.dart';
import 'package:volleyapp/features/club/domain/use_cases/get_filtered_club_by_name/get_filtered_club_by_name_params.dart';

class GetFilteredClubByNameUseCase
    implements UseCase<List<Club>, GetFilteredClubByNameParams> {
  final ClubRepository repository;

  GetFilteredClubByNameUseCase(this.repository);

  @override
  Future<Either<Failure, List<Club>>> call(GetFilteredClubByNameParams params) {
    return repository.getClubsFilteredByName(params.query);
  }
}
