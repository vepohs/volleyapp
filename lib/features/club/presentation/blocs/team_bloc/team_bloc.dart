import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/club/domain/entities/club.dart';
import 'package:volleyapp/features/club/presentation/blocs/team_bloc/team_event.dart';
import 'package:volleyapp/features/club/presentation/blocs/team_bloc/team_state.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/get_club_for_current_user/get_club_for_current_user_use_case.dart';
import 'package:volleyapp/features/club_team/domain/use_cases/get_all_team_by_club_id/get_all_team_by_club_id_params.dart';
import 'package:volleyapp/features/club_team/domain/use_cases/get_all_team_by_club_id/get_all_team_by_club_id_use_case.dart';
import 'package:volleyapp/features/team/domain/entities/team.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final GetClubForCurrentUserUseCase _getClubForCurrentUserUseCase;
  final GetAllTeamByClubId _getAllTeamByClubId;

  TeamBloc({
    required GetClubForCurrentUserUseCase getClubForCurrentUserUseCase,
    required GetAllTeamByClubId getAllTeamByClubId,
  })  : _getClubForCurrentUserUseCase = getClubForCurrentUserUseCase,
        _getAllTeamByClubId = getAllTeamByClubId,
        super(TeamInitial())
  {
    on<LoadMyClubTeams>(_onLoadMyClubTeams);
  }

  Future<void> _onLoadMyClubTeams(
      LoadMyClubTeams event,
      Emitter<TeamState> emit,
      ) async {
    emit(TeamLoading());

    final Either<Failure, Club> clubEither =
    await _getClubForCurrentUserUseCase();

    await clubEither.fold(
          (failure) async => emit(TeamError(failure.message)),
          (club) async {
        final Either<Failure, List<Team>> teamsEither =
        await _getAllTeamByClubId(
          GetAllTeamByClubIdParams(clubId: club.id),
        );

        teamsEither.fold(
              (failure) => emit(TeamError(failure.message)),
              (teams) => emit(TeamLoaded(teams: teams)),
        );
      },
    );
  }

}
