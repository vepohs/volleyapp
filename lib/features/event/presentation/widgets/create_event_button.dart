import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/app/di/service_locator.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/get_club_for_current_user/get_club_for_current_user_use_case.dart';
import 'package:volleyapp/features/event/domain/use_cases/add_event/add_event_use_case.dart';
import 'package:volleyapp/features/event/presentation/blocs/create_event/create_event_bloc.dart';
import 'package:volleyapp/features/event/presentation/widgets/create_event_sheet.dart';

class CreateEventButton extends StatelessWidget {
  const CreateEventButton({super.key});


  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _openSheet(context),
      icon: const Icon(Icons.add),
      label: const Text('Nouvel évènement'),
    );
  }


  void _openSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => BlocProvider(
        create: (_) => CreateEventBloc(addEventUseCase: locator<AddEventUseCase>(), getClubForCurrentUserUseCase: locator<GetClubForCurrentUserUseCase>()),
        child: const CreateEventSheet(),
      ),
    );
  }
}