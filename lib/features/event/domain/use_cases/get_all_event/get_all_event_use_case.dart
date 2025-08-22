import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case_without_params.dart';
import 'package:volleyapp/features/event/domain/entities/event.dart';
import 'package:volleyapp/features/event/domain/repositories/event_repository.dart';

class GetAllEventUseCase implements UseCaseWithoutParams<List<Event>> {
  EventRepository repository;

  GetAllEventUseCase(this.repository);

  @override
  Future<Either<Failure, List<Event>>> call() {
    return repository.getAllEvent();
  }
}
