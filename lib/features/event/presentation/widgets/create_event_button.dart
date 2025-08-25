import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      builder: (_) => BlocProvider.value(
        value: context.read<CreateEventBloc>(),
        child: const CreateEventSheet(),
      ),
    );
  }

}