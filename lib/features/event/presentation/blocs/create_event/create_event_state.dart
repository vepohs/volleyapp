import 'package:volleyapp/features/event/presentation/blocs/create_event/create_event_event.dart';

class CreateEventState {
  final CreateEventKind kind;
  final DateTime? startAt;
  final DateTime? endAt;
  final String location;

  final String? homeClubId;   // IDs only
  final String? homeTeamId;
  final String? awayClubId;
  final String? awayTeamId;
  final String competition;

  final String? trainingClubId;
  final String? trainingTeamId;
  final String coachId;
  final String notes;

  // ----- Field errors -----
  final String? startAtError;
  final String? endAtError;
  final String? locationError;
  final String? homeClubTeamError;
  final String? awayClubTeamError;
  final String? trainingClubTeamError;

  // ----- Submit/result -----
  final bool submitting;
  final bool? success;
  final String? error; // erreur "globale" (ex: remontée back)

  const CreateEventState({
    required this.kind,
    required this.startAt,
    required this.endAt,
    required this.location,
    required this.homeClubId,
    required this.homeTeamId,
    required this.awayClubId,
    required this.awayTeamId,
    required this.competition,
    required this.trainingClubId,
    required this.trainingTeamId,
    required this.coachId,
    required this.notes,
    required this.startAtError,
    required this.endAtError,
    required this.locationError,
    required this.homeClubTeamError,
    required this.awayClubTeamError,
    required this.trainingClubTeamError,
    required this.submitting,
    required this.success,
    required this.error,
  });

  factory CreateEventState.initial() => const CreateEventState(
    kind: CreateEventKind.match,
    startAt: null,
    endAt: null,
    location: '',
    homeClubId: null,
    homeTeamId: null,
    awayClubId: null,
    awayTeamId: null,
    competition: '',
    trainingClubId: null,
    trainingTeamId: null,
    coachId: '',
    notes: '',
    startAtError: null,
    endAtError: null,
    locationError: null,
    homeClubTeamError: null,
    awayClubTeamError: null,
    trainingClubTeamError: null,
    submitting: false,
    success: null,
    error: null,
  );

  CreateEventState copyWith({
    CreateEventKind? kind,
    DateTime? startAt,
    DateTime? endAt,
    String? location,
    String? homeClubId,
    String? homeTeamId,
    String? awayClubId,
    String? awayTeamId,
    String? competition,
    String? trainingClubId,
    String? trainingTeamId,
    String? coachId,
    String? notes,

    // field errors
    String? startAtError,
    String? endAtError,
    String? locationError,
    String? homeClubTeamError,
    String? awayClubTeamError,
    String? trainingClubTeamError,

    // submit/result
    bool? submitting,
    bool? success,
    String? error,

    // util: remettre à zéro toutes les erreurs de champ
    bool clearFieldErrors = false,
  }) {
    return CreateEventState(
      kind: kind ?? this.kind,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      location: location ?? this.location,
      homeClubId: homeClubId ?? this.homeClubId,
      homeTeamId: homeTeamId ?? this.homeTeamId,
      awayClubId: awayClubId ?? this.awayClubId,
      awayTeamId: awayTeamId ?? this.awayTeamId,
      competition: competition ?? this.competition,
      trainingClubId: trainingClubId ?? this.trainingClubId,
      trainingTeamId: trainingTeamId ?? this.trainingTeamId,
      coachId: coachId ?? this.coachId,
      notes: notes ?? this.notes,

      startAtError: clearFieldErrors ? null : (startAtError ?? this.startAtError),
      endAtError: clearFieldErrors ? null : (endAtError ?? this.endAtError),
      locationError: clearFieldErrors ? null : (locationError ?? this.locationError),
      homeClubTeamError: clearFieldErrors ? null : (homeClubTeamError ?? this.homeClubTeamError),
      awayClubTeamError: clearFieldErrors ? null : (awayClubTeamError ?? this.awayClubTeamError),
      trainingClubTeamError: clearFieldErrors ? null : (trainingClubTeamError ?? this.trainingClubTeamError),

      submitting: submitting ?? this.submitting,
      success: success ?? this.success,
      error: error,
    );
  }
}
