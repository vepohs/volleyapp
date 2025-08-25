import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:volleyapp/app/di/service_locator.dart';
import 'package:volleyapp/app/routing/app_route.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/get_club_for_current_user/get_club_for_current_user_use_case.dart';

import 'package:volleyapp/features/event/domain/use_cases/add_event/add_event_use_case.dart';
import 'package:volleyapp/features/event/presentation/blocs/create_event/create_event_bloc.dart';
import 'package:volleyapp/features/event/presentation/widgets/create_event_button.dart';
import 'package:volleyapp/features/event/presentation/widgets/event_list_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateEventBloc>(
      create: (_) => CreateEventBloc(
        addEventUseCase: locator<AddEventUseCase>(),
        getClubForCurrentUserUseCase: locator<GetClubForCurrentUserUseCase>(),
      ),
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
    );
  }
}

