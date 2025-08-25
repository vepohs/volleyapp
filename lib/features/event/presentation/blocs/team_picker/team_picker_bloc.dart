import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/club_team/domain/use_cases/get_all_team_by_club_id/get_all_team_by_club_id_params.dart';
import 'package:volleyapp/features/club_team/domain/use_cases/get_all_team_by_club_id/get_all_team_by_club_id_use_case.dart';
import 'package:volleyapp/features/event/presentation/blocs/team_picker/team_picker_event.dart';
import 'package:volleyapp/features/event/presentation/blocs/team_picker/team_picker_state.dart';
import 'package:volleyapp/features/team/domain/entities/team.dart';

class TeamPickerBloc extends Bloc<TeamPickerEvent, TeamPickerState> {
  final GetAllTeamByClubId _getTeamsByClub;

  TeamPickerBloc({required GetAllTeamByClubId getTeamsByClub})
    : _getTeamsByClub = getTeamsByClub,
      super(TeamPickerState.initial()) {
    on<TeamPickerLoadForClub>(_onLoadForClub);
    on<TeamSelected>(
      (e, emit) => emit(state.copyWith(selectedTeamId: e.teamId)),
    );
  }

  Future<void> _onLoadForClub(
    TeamPickerLoadForClub e,
    Emitter<TeamPickerState> emit,
  ) async {
    emit(
      state.copyWith(
        loading: true,
        error: null,
        clubId: e.clubId,
        teams: const [],
        selectedTeamId: null,
      ),
    );
    final Either<Failure, List<Team>> res = await _getTeamsByClub(
      GetAllTeamByClubIdParams(clubId: e.clubId),
    );
    res.fold(
      (f) => emit(
        state.copyWith(loading: false, error: f.message, teams: const []),
      ),
      (teams) => emit(state.copyWith(loading: false, teams: teams)),
    );
  }
}
