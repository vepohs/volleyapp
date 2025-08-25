import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/features/club/presentation/blocs/team_bloc/team_bloc.dart';
import 'package:volleyapp/features/club/presentation/blocs/team_bloc/team_state.dart';
import 'package:volleyapp/features/team/domain/entities/team.dart';

class TeamList extends StatelessWidget {
  const TeamList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamBloc, TeamState>(
      builder: (context, state) {
        if (state is TeamLoading || state is TeamInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TeamError) {
          return Center(child: Text(state.message));
        }
        if (state is TeamLoaded) {
          final List<Team> teams = state.teams;
          if (teams.isEmpty) {
            return const Center(child: Text('Aucune équipe pour ce club.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: teams.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final t = teams[index];
              return Card(
                elevation: 0.5,
                child: ListTile(
                  title: Text(t.name),
                  subtitle: Text('Catégorie: ${t.category} • Genre: ${t.gender} • Niveau: ${t.level}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}