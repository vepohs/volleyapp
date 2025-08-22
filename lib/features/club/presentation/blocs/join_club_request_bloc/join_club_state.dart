
import 'package:volleyapp/features/club/domain/entities/club.dart';

enum ClubSearchStatus { idle, loading, success, empty, failure }

class JoinClubState {
  final String query;
  final ClubSearchStatus status;
  final List<Club> results;
  final Club? selected;
  final String? error;
  final bool isSubmitting;
  final bool isSuccess;

  const JoinClubState({
    this.query = '',
    this.status = ClubSearchStatus.idle,
    this.results = const [],
    this.selected,
    this.error,
    this.isSubmitting = false,
    this.isSuccess = false,

  });

  JoinClubState copyWith({
    String? query,
    ClubSearchStatus? status,
    List<Club>? results,
    Club? selected,
    String? error,
    bool? isSubmitting,
    bool? isSuccess,
    bool resetSelected = false,

  }) => JoinClubState(
    query: query ?? this.query,
    status: status ?? this.status,
    results: results ?? this.results,
    selected: resetSelected ? null : (selected ?? this.selected),
    error: error,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isSuccess: isSuccess ?? this.isSuccess,
  );
}
