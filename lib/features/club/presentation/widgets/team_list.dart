import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/features/club/presentation/blocs/team_bloc/team_bloc.dart';
import 'package:volleyapp/features/club/presentation/blocs/team_bloc/team_event.dart';
import 'package:volleyapp/features/club/presentation/blocs/team_bloc/team_state.dart';
import 'package:volleyapp/features/team/domain/entities/team.dart';

class TeamList extends StatelessWidget {
  final String clubId;
  const TeamList({super.key, required this.clubId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeamBloc()..add(LoadTeamsByClubId(clubId: clubId)),
      child: BlocBuilder<TeamBloc, TeamState>(
        builder: (context, state) {
          if (state is TeamLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TeamError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context
                        .read<TeamBloc>()
                        .add(LoadTeamsByClubId(clubId: clubId)),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }
          if (state is TeamLoaded) {
            final teams = state.teams;
            if (teams.isEmpty) {
              return const Center(child: Text('Aucune équipe pour ce club.'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: teams.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final Team t = teams[index];
                return Card(
                  elevation: 0.5,
                  child: ListTile(
                    title: Text(t.name),
                    subtitle: Text(
                      'Catégorie: ${t.category} • Genre: ${t.gender} • Niveau: ${t.level}',
                    ),
                    // Pas d’avatarUrl demandé, on n’affiche pas de leading Image.
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Naviguer vers le détail si besoin
                    },
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink(); // TeamInitial
        },
      ),
    );
  }
}
