import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/event/data/datasources/event_datasource.dart';
import 'package:volleyapp/features/event/data/mappers/event_mapper.dart';
import 'package:volleyapp/features/event/data/mappers/result_json_mapper.dart';
import 'package:volleyapp/features/event/domain/entities/event.dart';
import 'package:volleyapp/features/event/domain/entities/event_details.dart';
import 'package:volleyapp/features/event/domain/entities/result.dart';
import 'package:volleyapp/features/event/domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventDatasource _datasource;
  final EventMapper _mapper = EventMapper();
  final ResultJsonMapper _resultMapper = ResultJsonMapper();

  EventRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, Event>> addEvent({
    required String clubId,
    required DateTime startAt,
    required DateTime endAt,
    required String location,
    required EventDetails details,
  }) async {
    try {
      final model = await _datasource.addEvent(
        clubId: clubId,
        startAt: startAt,
        endAt: endAt,
        location: location,
        type: _mapper.typeFromDetails(details),
        details: _mapper.detailsToJson(details),
      );

      final entity = _mapper.from(model);
      return Right(entity);
    } catch (e) {
      return Left(Failure('Add event failed: $e'));
    }
  }

  @override
  Future<Either<Failure, Option<Event>>> getEventById({
    required String id,
  }) async {
    try {
      final model = await _datasource.getEventById(id);
      if (model == null) return Right(None());
      return Right(Some(_mapper.from(model)));
    } catch (e) {
      return Left(Failure('Get event failed: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateMatchResult({
    required String eventId,
    required Result result,
  }) async {
    try {
      await _datasource.updateMatchResult(
        eventId: eventId,
        resultJson: _resultMapper.to(result),
      );
      return const Right(unit);
    } catch (e) {
      return Left(Failure('Update match result failed: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getAllEventByClubId({
    required String clubId,
  }) async {
    try {
      final models = await _datasource.getAllEventByClubId(clubId: clubId);
      final entities = models.map((m) => _mapper.from(m)).toList();
      return Right(entities);
    } catch (e) {
      return Left(Failure('Get all events failed: $e'));
    }
  }
}
