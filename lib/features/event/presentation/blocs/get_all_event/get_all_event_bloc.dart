import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/get_club_for_current_user/get_club_for_current_user_use_case.dart';
import 'package:volleyapp/features/event/domain/use_cases/get_all_event/get_all_event_by_club_id_params.dart';
import 'package:volleyapp/features/event/domain/use_cases/get_all_event/get_all_event_by_club_id_use_case.dart';
import 'package:volleyapp/features/event/presentation/blocs/get_all_event/get_all_event_event.dart';
import 'package:volleyapp/features/event/presentation/blocs/get_all_event/get_all_event_state.dart';

class GetAllEventBloc extends Bloc<GetAllEventEvent, GetAllEventState> {
  final GetAllEventByClubIdUseCase getAllEventUseCase;
  final GetClubForCurrentUserUseCase getClubForCurrentUserUseCase;

  GetAllEventBloc({
    required this.getAllEventUseCase,
    required this.getClubForCurrentUserUseCase,
  }) : super(GetAllEventState.initial()) {
    on<GetAllEventsStarted>(_onStarted);
  }

  Future<void> _onStarted(
    GetAllEventsStarted event,
    Emitter<GetAllEventState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    final clubResult = await getClubForCurrentUserUseCase();
    await clubResult.fold(
      (failure) async {
        emit(state.copyWith(loading: false, error: failure.message));
      },
      (club) async {
        final res = await getAllEventUseCase(
          GetAllEventByClubIdParams(clubId: club.id),
        );
        res.fold(
          (failure) =>
              emit(state.copyWith(loading: false, error: failure.message)),
          (events) => emit(state.copyWith(loading: false, events: events)),
        );
      },
    );
  }
}
