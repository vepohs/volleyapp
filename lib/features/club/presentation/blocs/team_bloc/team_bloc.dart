import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/features/club/presentation/blocs/team_bloc/team_event.dart';
import 'package:volleyapp/features/club/presentation/blocs/team_bloc/team_state.dart';
import 'package:volleyapp/features/team/domain/entities/team.dart';

class MockGetAllTeamByClubIdUseCase {
  Future<List<Team>> call({required String clubId}) async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      const Team(
        id: 'team_1',
        name: 'Les Aigles',
        category: 'U18',
        gender: 'Mixte',
        level: 'Débutant',
      ),
      const Team(
        id: 'team_2',
        name: 'Les Tigres',
        category: 'Senior',
        gender: 'Féminin',
        level: 'Avancé',
      ),
      const Team(
        id: 'team_1',
        name: 'Les Aigles',
        category: 'U18',
        gender: 'Mixte',
        level: 'Débutant',
      ),
      const Team(
        id: 'team_2',
        name: 'Les Tigres',
        category: 'Senior',
        gender: 'Féminin',
        level: 'Avancé',
      ),
      const Team(
        id: 'team_1',
        name: 'Les Aigles',
        category: 'U18',
        gender: 'Mixte',
        level: 'Débutant',
      ),
      const Team(
        id: 'team_2',
        name: 'Les Tigres',
        category: 'Senior',
        gender: 'Féminin',
        level: 'Avancé',
      ),
      const Team(
        id: 'team_1',
        name: 'Les Aigles',
        category: 'U18',
        gender: 'Mixte',
        level: 'Débutant',
      ),
      const Team(
        id: 'team_2',
        name: 'Les Tigres',
        category: 'Senior',
        gender: 'Féminin',
        level: 'Avancé',
      ),
      const Team(
        id: 'team_1',
        name: 'Les Aigles',
        category: 'U18',
        gender: 'Mixte',
        level: 'Débutant',
      ),
      const Team(
        id: 'team_2',
        name: 'Les Tigres',
        category: 'Senior',
        gender: 'Féminin',
        level: 'Avancé',
      ),
      const Team(
        id: 'team_1',
        name: 'Les Aigles',
        category: 'U18',
        gender: 'Mixte',
        level: 'Débutant',
      ),
      const Team(
        id: 'team_2',
        name: 'Les Tigres',
        category: 'Senior',
        gender: 'Féminin',
        level: 'Avancé',
      ),
      const Team(
        id: 'team_1',
        name: 'Les Aigles',
        category: 'U18',
        gender: 'Mixte',
        level: 'Débutant',
      ),
      const Team(
        id: 'team_2',
        name: 'Les Tigres',
        category: 'Senior',
        gender: 'Féminin',
        level: 'Avancé',
      ),
      const Team(
        id: 'team_1',
        name: 'Les Aigles',
        category: 'U18',
        gender: 'Mixte',
        level: 'Débutant',
      ),
      const Team(
        id: 'team_2',
        name: 'Les Tigres',
        category: 'Senior',
        gender: 'Féminin',
        level: 'Avancé',
      ),

    ];
  }
}

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final MockGetAllTeamByClubIdUseCase getAllTeamByClubId;

  TeamBloc()
      : getAllTeamByClubId = MockGetAllTeamByClubIdUseCase(),
        super(TeamInitial()) {
    on<LoadTeamsByClubId>(_onLoadTeamsByClubId);
  }

  Future<void> _onLoadTeamsByClubId(
      LoadTeamsByClubId event,
      Emitter<TeamState> emit,
      ) async {
    emit(TeamLoading());
    try {
      final teams = await getAllTeamByClubId(clubId: event.clubId);
      emit(TeamLoaded(teams: teams));
    } catch (e) {
      emit(TeamError("Erreur lors du chargement des équipes"));
    }
  }
}
