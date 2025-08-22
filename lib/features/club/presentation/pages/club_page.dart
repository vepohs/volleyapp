import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:volleyapp/app/routing/app_route.dart';

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
        title: const Text(
          "Mettre le nom du club quand clubBloc ok ",
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.push(AppRoute.team.path),
          child: const Text('Créer une équipe'),
        ),
      ),
    );
  }
}
