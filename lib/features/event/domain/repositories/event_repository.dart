import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/event/domain/entities/event.dart';
import 'package:volleyapp/features/event/domain/entities/event_details.dart';
import 'package:volleyapp/features/event/domain/entities/result.dart';

abstract class EventRepository {
  Future<Either<Failure, Event>> addEvent({
    required String clubId,
    required DateTime startAt,
    required DateTime endAt,
    required String location,
    required EventDetails details,
  });

  Future<Either<Failure, Option<Event>>> getEventById({required String id});

  Future<Either<Failure, Unit>> updateMatchResult({
    required String eventId,
    required Result result,
  });

  Future<Either<Failure, List<Event>>> getAllEventByClubId({required String clubId});
}
