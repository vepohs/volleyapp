import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case.dart';
import 'package:volleyapp/features/event/domain/entities/event.dart';
import 'package:volleyapp/features/event/domain/repositories/event_repository.dart';
import 'package:volleyapp/features/event/domain/use_cases/add_event/add_event_params.dart';

class AddEventUseCase implements UseCase<Event, AddEventParams> {
  final EventRepository repository;

  AddEventUseCase(this.repository);

  @override
  Future<Either<Failure, Event>> call(AddEventParams params) {
    return repository.addEvent(
      startAt: params.startAt,
      endAt: params.endAt,
      location: params.location,
      details: params.details,
    );
  }
}
