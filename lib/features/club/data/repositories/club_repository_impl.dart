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
}
