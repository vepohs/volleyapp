import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart'; // 👈

import 'package:volleyapp/app/di/service_locator.dart';
import 'package:volleyapp/app/routing/app_route.dart';
import 'package:volleyapp/features/event/domain/use_cases/add_event/add_event_use_case.dart';
import 'package:volleyapp/features/event/domain/use_cases/get_all_event/get_all_event_use_case.dart';

import 'package:volleyapp/features/event/presentation/widgets/event_list_view.dart';
import 'package:volleyapp/features/event/presentation/blocs/add_event_bloc.dart';
import 'package:volleyapp/features/event/presentation/widgets/create_event_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddEventBloc>(
      create: (_) => AddEventBloc(locator<AddEventUseCase>()),
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
        body: EventListView(
          getAllEventUseCase: locator<GetAllEventUseCase>(),
        ),
        floatingActionButton: const CreateEventButton(),
      ),
    );
  }
}
