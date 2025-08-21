
import 'package:volleyapp/features/club/domain/entities/club.dart';

enum ClubSearchStatus { idle, loading, success, empty, failure }

class ClubSearchState {
  final String query;
  final ClubSearchStatus status;
  final List<Club> results;
  final Club? selected;
  final String? error;

  const ClubSearchState({
    this.query = '',
    this.status = ClubSearchStatus.idle,
    this.results = const [],
    this.selected,
    this.error,
  });

  ClubSearchState copyWith({
    String? query,
    ClubSearchStatus? status,
    List<Club>? results,
    Club? selected,
    String? error,
  }) => ClubSearchState(
    query: query ?? this.query,
    status: status ?? this.status,
    results: results ?? this.results,
    selected: selected ?? this.selected,
    error: error,
  );
}
