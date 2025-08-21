import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/club/domain/entities/club.dart';
import 'package:volleyapp/features/club/domain/repositories/club_repository.dart';

class ClubRepositoryImpl implements ClubRepository {

  @override
  Future<Either<Failure, Club>> addClub({required String id, required String name, String? avatarUrl}) {

  }
}
