import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/club/domain/entities/club.dart';

abstract class ClubRepository {
  Future<Either<Failure, Club>> addClub({required String name,String? avatarUrl});
}
