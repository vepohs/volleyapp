import 'package:flutter/material.dart';
import 'package:volleyapp/features/club/presentation/pages/create_team_page.dart';

class ClubPage extends StatelessWidget {

  const ClubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mettre le nom du club quand clubBloc ok "), // Affiche le nom du club
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigation vers la page CreateTeam
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CreateTeamPage(),
              ),
            );
          },
          child: const Text('Créer une équipe'),
        ),
      ),
    );
  }
}


