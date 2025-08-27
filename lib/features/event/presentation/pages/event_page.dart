import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:volleyapp/app/di/service_locator.dart';
import 'package:volleyapp/app/routing/app_route.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/get_club_for_current_user/get_club_for_current_user_use_case.dart';
import 'package:volleyapp/features/event/domain/use_cases/add_event/add_event_use_case.dart';
import 'package:volleyapp/features/event/domain/use_cases/get_all_event/get_all_event_by_club_id_use_case.dart';

import 'package:volleyapp/features/event/presentation/blocs/create_event/create_event_bloc.dart';
import 'package:volleyapp/features/event/presentation/blocs/create_event/create_event_state.dart';
import 'package:volleyapp/features/event/presentation/blocs/get_all_event/get_all_event_bloc.dart';
import 'package:volleyapp/features/event/presentation/blocs/get_all_event/get_all_event_event.dart';

import 'package:volleyapp/features/event/presentation/widgets/create_event_button.dart';
import 'package:volleyapp/features/event/presentation/widgets/event_list_view.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CreateEventBloc>(
          create: (_) => CreateEventBloc(
            addEventUseCase: locator<AddEventUseCase>(),
            getClubForCurrentUserUseCase: locator<GetClubForCurrentUserUseCase>(),
          ),
        ),
        BlocProvider<GetAllEventBloc>(
          create: (_) => GetAllEventBloc(
            getAllEventUseCase: locator<GetAllEventByClubIdUseCase>(),
            getClubForCurrentUserUseCase: locator<GetClubForCurrentUserUseCase>(),
          )..add(GetAllEventsStarted()),
        ),
      ],
      child: BlocListener<CreateEventBloc, CreateEventState>(
        listenWhen: (p, c) => c.success == true,
        listener: (context, state) {
          context.read<GetAllEventBloc>().add(GetAllEventsStarted());
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Accueil'),
            actions: [
              IconButton(
                icon: const Icon(Icons.groups_2),
                tooltip: 'Équipes',
                onPressed: () => context.push(AppRoute.club.path),
              ),
            ],
          ),
          body: const EventListView(),
          floatingActionButton: const CreateEventButton(),
        ),
      ),
    );
  }
}

