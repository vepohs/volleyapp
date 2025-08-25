import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/core/use_cases/use_case.dart';
import 'package:volleyapp/features/event/domain/entities/event.dart';
import 'package:volleyapp/features/event/domain/repositories/event_repository.dart';
import 'package:volleyapp/features/event/domain/use_cases/get_all_event/get_all_event_by_club_id_params.dart';

class GetAllEventByClubIdUseCase
    implements UseCase<List<Event>, GetAllEventByClubIdParams> {
  EventRepository repository;

  GetAllEventByClubIdUseCase(this.repository);

  @override
  Future<Either<Failure, List<Event>>> call(GetAllEventByClubIdParams params) {
    return repository.getAllEventByClubId(clubId: params.clubId);
  }


}
