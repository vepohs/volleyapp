import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:volleyapp/app/routing/app_route.dart';
import 'package:volleyapp/features/club/presentation/widgets/team_list.dart';

class ClubPage extends StatelessWidget {
  const ClubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text("Mettre le nom du club quand clubBloc ok"),
      ),
      body: const TeamList(clubId: "9"), // la liste occupe tout l'espace
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.push(AppRoute.team.path),
                  child: const Text('Créer une équipe'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Pas d'action pour l'instant
                  },
                  child: const Text('Voir demande'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}