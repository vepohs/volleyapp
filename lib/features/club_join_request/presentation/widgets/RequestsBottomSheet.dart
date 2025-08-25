import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/features/club_join_request/presentation/blocs/request_model_bloc/request_modal_bloc.dart';
import 'package:volleyapp/features/club_join_request/presentation/blocs/request_model_bloc/request_modal_event.dart';
import 'package:volleyapp/features/club_join_request/presentation/blocs/request_model_bloc/request_modal_state.dart';
import 'package:volleyapp/features/club_membership/domain/entities/role.dart';

class RequestsBottomSheet extends StatelessWidget {
  const RequestsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<RequestsModalBloc, RequestsModalState>(
        builder: (context, state) {
          if (state is RequestsModalLoading || state is RequestsModalInitial) {
            return const SizedBox(height: 300, child: Center(child: CircularProgressIndicator()));
          }
          if (state is RequestsModalError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context.read<RequestsModalBloc>().add(LoadRequestsModal()),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }
          if (state is RequestsModalLoaded) {
            final teams = state.teams;
            final requests = state.requests;

            // Prépare les items de rôle une fois
            final roleItems = Role.all
                .where((r) => r.id != Role.presidenggggg.id) // exclut le président
                .map((r) => DropdownMenuItem<String>(
              value: r.id,
              child: Text(r.name),
            ))
                .toList();

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              minChildSize: 0.4,
              maxChildSize: 0.95,
              builder: (_, controller) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Demandes — ${state.club.name}',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.separated(
                          controller: controller,
                          itemCount: requests.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, i) {
                            final r = requests[i];
                            final userName = '${r.user.firstname} ${r.user.lastname}';

                            return Card(
                              elevation: 0.5,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(userName, style: Theme.of(context).textTheme.titleMedium),
                                    const SizedBox(height: 8),

                                    // Dropdown des équipes
                                    DropdownButtonFormField<String>(
                                      decoration: const InputDecoration(
                                        labelText: 'Affecter à une équipe',
                                        border: OutlineInputBorder(),
                                      ),
                                      items: teams
                                          .map((t) => DropdownMenuItem(
                                        value: t.id,
                                        child: Text(t.name),
                                      ))
                                          .toList(),
                                      value: null, // pas de valeur par défaut pour l’instant
                                      onChanged: (_) {}, // à brancher plus tard
                                    ),

                                    const SizedBox(height: 12),

                                    // Dropdown des rôles
                                    DropdownButtonFormField<String>(
                                      decoration: const InputDecoration(
                                        labelText: 'Rôle',
                                        border: OutlineInputBorder(),
                                      ),
                                      items: roleItems,
                                      value: null, // pas de valeur par défaut pour l’instant
                                      onChanged: (_) {}, // à brancher plus tard
                                    ),

                                    const SizedBox(height: 12),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () {}, // plus tard: reject
                                            child: const Text('Refuser'),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {}, // plus tard: accept
                                            child: const Text('Accepter'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}