import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/get_club_for_current_user/get_club_for_current_user_use_case.dart';
import 'package:volleyapp/features/event/domain/entities/event.dart';
import 'package:volleyapp/features/event/domain/entities/event_details.dart';
import 'package:volleyapp/features/event/domain/entities/match_details.dart';
import 'package:volleyapp/features/event/domain/entities/training_details.dart';
import 'package:volleyapp/features/event/domain/use_cases/add_event/add_event_params.dart';
import 'package:volleyapp/features/event/domain/use_cases/add_event/add_event_use_case.dart';
import 'package:volleyapp/features/event/presentation/blocs/create_event/create_event_event.dart';
import 'package:volleyapp/features/event/presentation/blocs/create_event/create_event_state.dart';

class CreateEventBloc extends Bloc<CreateEventEvent, CreateEventState> {
  final AddEventUseCase _addEvent;
  final GetClubForCurrentUserUseCase _getClubForCurrentUserUseCase;

  CreateEventBloc({
    required AddEventUseCase addEventUseCase,
    required GetClubForCurrentUserUseCase getClubForCurrentUserUseCase,
  })  : _addEvent = addEventUseCase,
        _getClubForCurrentUserUseCase = getClubForCurrentUserUseCase,
        super(CreateEventState.initial()) {
    on<EventKindChanged>((e, emit) => emit(state.copyWith(kind: e.kind, clearFieldErrors: true)));
    on<StartAtChanged>((e, emit) => emit(state.copyWith(startAt: e.value, startAtError: null)));
    on<EndAtChanged>((e, emit) => emit(state.copyWith(endAt: e.value, endAtError: null)));
    on<LocationChanged>((e, emit) => emit(state.copyWith(location: e.value, locationError: null)));
    on<CompetitionChanged>((e, emit) => emit(state.copyWith(competition: e.value)));
    on<CoachChanged>((e, emit) => emit(state.copyWith(coachId: e.value)));
    on<NotesChanged>((e, emit) => emit(state.copyWith(notes: e.value)));

    on<HomeClubChanged>((e, emit) => emit(state.copyWith(
      homeClubId: e.clubId,
      homeTeamId: null,
      homeClubTeamError: null,
    )));
    on<HomeTeamChanged>((e, emit) => emit(state.copyWith(
      homeTeamId: e.teamId,
      homeClubTeamError: null,
    )));

    on<AwayClubChanged>((e, emit) => emit(state.copyWith(
      awayClubId: e.clubId,
      awayTeamId: null,
      awayClubTeamError: null,
    )));
    on<AwayTeamChanged>((e, emit) => emit(state.copyWith(
      awayTeamId: e.teamId,
      awayClubTeamError: null,
    )));

    on<TrainingClubChanged>((e, emit) => emit(state.copyWith(
      trainingClubId: e.clubId,
      trainingTeamId: null,
      trainingClubTeamError: null,
    )));
    on<TrainingTeamChanged>((e, emit) => emit(state.copyWith(
      trainingTeamId: e.teamId,
      trainingClubTeamError: null,
    )));

    on<CreateEventSubmitted>(_onSubmit);
  }

  Future<void> _onSubmit(CreateEventSubmitted event, Emitter<CreateEventState> emit) async {
    emit(state.copyWith(clearFieldErrors: true, error: null, success: null));

    String? startErr, endErr, locationErr, homeErr, awayErr, trainingErr;

    if (state.startAt == null) startErr = 'Début requis';
    if (state.endAt == null) endErr = 'Fin requise';
    if (state.startAt != null && state.endAt != null && !state.endAt!.isAfter(state.startAt!)) {
      startErr ??= 'Début invalide';
      endErr = 'La fin doit être après le début';
    }
    if (state.location.trim().isEmpty) locationErr = 'Lieu requis';

    if (state.kind == CreateEventKind.match) {
      if (state.homeClubId == null || state.homeTeamId == null) {
        homeErr = 'Sélectionne club & équipe (domicile)';
      }
      if (state.awayClubId == null || state.awayTeamId == null) {
        awayErr = 'Sélectionne club & équipe (extérieur)';
      }
    } else {
      if (state.trainingClubId == null || state.trainingTeamId == null) {
        trainingErr = "Sélectionne club & équipe d'entraînement";
      }
    }

    final hasErrors = [startErr, endErr, locationErr, homeErr, awayErr, trainingErr].any((e) => e != null);
    if (hasErrors) {
      emit(state.copyWith(
        startAtError: startErr,
        endAtError: endErr,
        locationError: locationErr,
        homeClubTeamError: homeErr,
        awayClubTeamError: awayErr,
        trainingClubTeamError: trainingErr,
        submitting: false,
        success: false,
      ));
      return;
    }

    late final EventDetails details;
    if (state.kind == CreateEventKind.match) {
      details = MatchDetails(
        homeClubId: state.homeClubId!,
        homeTeamId: state.homeTeamId!,
        awayClubId: state.awayClubId!,
        awayTeamId: state.awayTeamId!,
        competition: state.competition.trim().isEmpty ? null : state.competition.trim(),
      );
    } else {
      details = TrainingDetails(
        clubId: state.trainingClubId!,
        teamId: state.trainingTeamId!,
        coachId: state.coachId.trim().isEmpty ? null : state.coachId.trim(),
        notes: state.notes.trim().isEmpty ? null : state.notes.trim(),
      );
    }

    emit(state.copyWith(submitting: true));

    final clubResult = await _getClubForCurrentUserUseCase();

    final Either<Failure, Event> res = await clubResult.fold(
          (failure) async => Left<Failure, Event>(failure),
          (club) async {
        return await _addEvent(AddEventParams(
          clubId: club.id,
          startAt: state.startAt!,
          endAt: state.endAt!,
          location: state.location.trim(),
          details: details,
        ));
      },
    );

    res.fold(
          (failure) => emit(state.copyWith(submitting: false, success: false, error: failure.message)),
          (_) => emit(state.copyWith(submitting: false, success: true, error: null)),
    );
  }
}
