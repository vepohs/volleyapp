import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case.dart';
import 'package:volleyapp/features/event/domain/repositories/event_repository.dart';
import 'package:volleyapp/features/event/domain/use_cases/update_match_result/update_match_result_params.dart';

class UpdateMatchResultUseCase implements UseCase<Unit, UpdateMatchResultParams> {
  final EventRepository repository;
  UpdateMatchResultUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateMatchResultParams p) {
    return repository.updateMatchResult(
      eventId: p.eventId,
      result: p.result,
    );
  }
}
