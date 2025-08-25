import 'package:volleyapp/features/event/domain/entities/event.dart';

class GetAllEventState {
  final bool loading;
  final List<Event> events;
  final String? error;

  const GetAllEventState({
    required this.loading,
    required this.events,
    required this.error,
  });

  factory GetAllEventState.initial() =>
      const GetAllEventState(loading: false, events: [], error: null);

  GetAllEventState copyWith({
    bool? loading,
    List<Event>? events,
    String? error,
  }) {
    return GetAllEventState(
      loading: loading ?? this.loading,
      events: events ?? this.events,
      error: error,
    );
  }
}