import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/club/data/datasources/club_datasource.dart';
import 'package:volleyapp/features/club/data/mappers/club_mapper.dart';
import 'package:volleyapp/features/club/domain/entities/club.dart';
import 'package:volleyapp/features/club/domain/repositories/club_repository.dart';

class ClubRepositoryImpl implements ClubRepository {
  final ClubDataSource _dataSource;
  final ClubMapper _mapper = ClubMapper();

  ClubRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, Club>> addClub({
    required String name,
    String? avatarUrl,
  }) async {
    try {
      final model = await _dataSource.addClub(
        name: name,
        avatarUrl: avatarUrl,
      );

      final entity = _mapper.from(model);

      return Right(entity);
    } catch (e) {
      return Left(Failure('Add club failed: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Club>>> getClubsFilteredByName(String query) async {
    try {
      final models = await _dataSource.getClubsFilteredByName(query);

      final entities = models.map(_mapper.from).toList();
      return Right(entities);
    } catch (e) {
      return Left(Failure('Get clubs filtered by name failed: $e'));
    }
  }

  @override
  Future<Either<Failure, Club>> getClubById({required String clubId}) async {
    try {
      final model = await _dataSource.getClubById(clubId: clubId);

      if (model == null) {
        return Left(Failure('Club not found with id: $clubId'));
      }
      final entity = _mapper.from(model);
      return Right(entity);
    } catch (e) {
      return Left(Failure('Get club by id failed: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Club>>> getAllClub() async {
    try {
      final models = await _dataSource.getAllClub();
      final entities = models.map(_mapper.from).toList();
      return Right(entities);
    } catch (e) {
      return Left(Failure('Get all clubs failed: $e'));
    }
  }


}
