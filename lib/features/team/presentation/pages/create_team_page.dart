import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:volleyapp/app/di/service_locator.dart';
import 'package:volleyapp/features/club/presentation/blocs/create_team_from_bloc/create_team_from_bloc.dart';
import 'package:volleyapp/features/club/presentation/blocs/create_team_from_bloc/create_team_from_event.dart';
import 'package:volleyapp/features/club/presentation/blocs/create_team_from_bloc/create_team_from_state.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/get_club_by_user_id/get_club_user_id_use_case.dart';
import 'package:volleyapp/features/club_team/domain/use_cases/add_club_team/add_club_team_use_case.dart';
import 'package:volleyapp/features/team/domain/use_cases/add_team/add_team_use_case.dart';

class CreateTeamPage extends StatelessWidget {
  const CreateTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateTeamFormBloc(
        getClubUserIdUseCase: locator<GetClubUserIdUseCase>(),
       addTeamUseCase: locator<AddTeamUseCase>(),
        auth: locator<FirebaseAuth>(),
       addClubTeamUseCase: locator<AddClubTeamUseCase>(),
      ),
      child: const CreateTeamFormView(),
    );
  }
}

class CreateTeamFormView extends StatelessWidget {
  const CreateTeamFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer une équipe')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocListener<CreateTeamFormBloc, CreateTeamFormState>(
          listenWhen: (previous, current) =>
          previous.isSuccess != current.isSuccess,
          listener: (context, state) async {
            if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Équipe créée avec succès"),
                  duration: Duration(seconds: 2),
                ),
              );
              await Future.delayed(const Duration(seconds: 1));
              if (context.mounted) context.pop(true);
            }
          },
          child: BlocBuilder<CreateTeamFormBloc, CreateTeamFormState>(
            builder: (context, state) {
              final bloc = context.read<CreateTeamFormBloc>();

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Nom de l\'équipe'),
                      onChanged: (value) => bloc.add(TeamNameChanged(value)),
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Catégorie'),
                      onChanged: (value) => bloc.add(TeamCategoryChanged(value)),
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Genre'),
                      onChanged: (value) => bloc.add(TeamGenderChanged(value)),
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Niveau'),
                      onChanged: (value) => bloc.add(TeamLevelChanged(value)),
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'URL Avatar'),
                      onChanged: (value) => bloc.add(TeamAvatarChanged(value)),
                    ),
                    const SizedBox(height: 20),
                    if (state.errorMessage != null)
                      Text(state.errorMessage!,
                          style: const TextStyle(color: Colors.red)),
                    if (state.isSubmitting) const CircularProgressIndicator(),
                    ElevatedButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () => bloc.add(SubmitTeamForm()),
                      child: const Text('Créer l\'équipe'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}