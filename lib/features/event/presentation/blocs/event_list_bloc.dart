import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/features/event/domain/use_cases/get_all_event/get_all_event_use_case.dart';
import 'package:volleyapp/features/event/presentation/blocs/event_list_event.dart';
import 'package:volleyapp/features/event/presentation/blocs/event_list_state.dart';


class EventListBloc extends Bloc<EventListEvent, EventListState> {
  final GetAllEventUseCase _getAllEvent;

  EventListBloc(this._getAllEvent) : super(const EventListInitial()) {
    on<EventListRequested>(_onRequested);
    on<EventListRefreshed>(_onRefreshed);
  }

  Future<void> _onRequested(
      EventListRequested event,
      Emitter<EventListState> emit,
      ) async {
    emit(const EventListLoading());
    final either = await _getAllEvent();
    either.fold(
          (failure) => emit(EventListFailure(failure.message)),
          (events) => emit(EventListLoaded(events)),
    );
  }

  Future<void> _onRefreshed(
      EventListRefreshed event,
      Emitter<EventListState> emit,
      ) async {
    // On peut choisir de ne pas repasser par Loading visuellement
    final either = await _getAllEvent();
    either.fold(
          (failure) => emit(EventListFailure(failure.message)),
          (events) => emit(EventListLoaded(events)),
    );
  }
}
