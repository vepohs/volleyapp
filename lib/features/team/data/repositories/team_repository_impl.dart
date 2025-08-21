import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/team/data/datasources/team_datasource.dart';
import 'package:volleyapp/features/team/data/mappers/team_mapper.dart';
import 'package:volleyapp/features/team/domain/entities/team.dart';
import 'package:volleyapp/features/team/domain/repositories/team_repository.dart';

class TeamRepositoryImpl implements TeamRepository {
  final TeamDataSource _dataSource;
  final TeamMapper _mapper = TeamMapper();

  TeamRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, Team>> addTeam({
    required String name,
    required String category,
    required String gender,
    required String level,
    String? avatarUrl,
  }) async {
    try {
      final model = await _dataSource.addTeam(
        name: name,
        category: category,
        gender: gender,
        level: level,
        avatarUrl: avatarUrl,
      );

      final entity = _mapper.from(model);

      return Right(entity);
    } catch (e) {
      return Left(Failure('Add team failed: $e'));
    }
  }
}
