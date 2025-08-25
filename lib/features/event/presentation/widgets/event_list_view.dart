import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/app/di/service_locator.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/get_club_for_current_user/get_club_for_current_user_use_case.dart';
import 'package:volleyapp/features/event/domain/use_cases/get_all_event/get_all_event_by_club_id_use_case.dart';
import 'package:volleyapp/features/event/presentation/blocs/get_all_event/get_all_event_bloc.dart';
import 'package:volleyapp/features/event/presentation/blocs/get_all_event/get_all_event_event.dart';
import 'package:volleyapp/features/event/presentation/blocs/get_all_event/get_all_event_state.dart';
import 'package:volleyapp/features/event/presentation/widgets/event_card.dart';

class EventListView extends StatelessWidget {
  const EventListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetAllEventBloc>(
      create: (_) => GetAllEventBloc(
        getAllEventUseCase: locator<GetAllEventByClubIdUseCase>(),
        getClubForCurrentUserUseCase: locator<GetClubForCurrentUserUseCase>(),
      )..add(GetAllEventsStarted()),
      child: BlocBuilder<GetAllEventBloc, GetAllEventState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Erreur : ${state.error}"),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.read<GetAllEventBloc>().add(GetAllEventsStarted()),
                    child: const Text("Réessayer"),
                  ),
                ],
              ),
            );
          }
          if (state.events.isEmpty) {
            return const Center(child: Text("Aucun évènement trouvé"));
          }

          return ListView.builder(
            itemCount: state.events.length,
            itemBuilder: (_, i) => EventCard(event: state.events[i]),
          );
        },
      ),
    );
  }
}
