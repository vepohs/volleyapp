import 'package:volleyapp/features/team/domain/entities/team.dart';

class TeamPickerState {
  final bool loading;
  final String? clubId;
  final List<Team> teams;
  final String? selectedTeamId;
  final String? error;


  const TeamPickerState({
    required this.loading,
    required this.teams,
    this.clubId,
    this.selectedTeamId,
    this.error,
  });


  factory TeamPickerState.initial() => const TeamPickerState(
    loading: false,
    teams: [],
  );


  TeamPickerState copyWith({
    bool? loading,
    String? clubId,
    List<Team>? teams,
    String? selectedTeamId,
    String? error,
  }) {
    return TeamPickerState(
      loading: loading ?? this.loading,
      clubId: clubId ?? this.clubId,
      teams: teams ?? this.teams,
      selectedTeamId: selectedTeamId,
      error: error,
    );
  }
}