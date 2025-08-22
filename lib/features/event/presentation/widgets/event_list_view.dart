import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/features/event/domain/use_cases/get_all_event/get_all_event_use_case.dart';
import 'package:volleyapp/features/event/presentation/blocs/event_list_bloc.dart';
import 'package:volleyapp/features/event/presentation/blocs/event_list_event.dart';
import 'package:volleyapp/features/event/presentation/blocs/event_list_state.dart';

import 'package:volleyapp/features/event/presentation/widgets/event_card.dart';

class EventListView extends StatelessWidget {
  final GetAllEventUseCase getAllEventUseCase;
  const EventListView({super.key, required this.getAllEventUseCase});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EventListBloc(getAllEventUseCase)..add(const EventListRequested()),
      child: BlocBuilder<EventListBloc, EventListState>(
        builder: (context, state) {
          if (state is EventListLoading || state is EventListInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is EventListFailure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.read<EventListBloc>().add(const EventListRequested()),
                    child: const Text("Réessayer"),
                  ),
                ],
              ),
            );
          }
          final events = (state as EventListLoaded).events;
          if (events.isEmpty) {
            return const Center(child: Text("Aucun évènement pour l’instant."));
          }
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (_, i) => EventCard(event: events[i]),
          );
        },
      ),
    );
  }
}
