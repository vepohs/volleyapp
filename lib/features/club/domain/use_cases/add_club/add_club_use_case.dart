import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case.dart';
import 'package:volleyapp/features/club/domain/entities/club.dart';
import 'package:volleyapp/features/club/domain/repositories/club_repository.dart';
import 'add_club_params.dart';

class AddClubUseCase implements UseCase<Club, AddClubParams> {
  final ClubRepository repository;

  AddClubUseCase(this.repository);

  @override
  Future<Either<Failure, Club>> call(AddClubParams params) {
    return repository.addClub(
      id: params.id,
      name: params.name,
      avatarUrl: params.avatarUrl,
    );
  }
}
