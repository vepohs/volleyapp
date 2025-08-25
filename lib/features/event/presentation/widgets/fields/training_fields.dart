import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/features/event/presentation/blocs/create_event/create_event_bloc.dart';
import 'package:volleyapp/features/event/presentation/blocs/create_event/create_event_event.dart';
import 'package:volleyapp/features/event/presentation/blocs/create_event/create_event_state.dart';
import 'package:volleyapp/features/event/presentation/widgets/pickers/club_picker.dart';
import 'package:volleyapp/features/event/presentation/widgets/pickers/team_picker.dart';

class TrainingFields extends StatefulWidget {
  const TrainingFields({super.key});

  @override
  State<TrainingFields> createState() => _TrainingFieldsState();
}

class _TrainingFieldsState extends State<TrainingFields> {
  String? _clubId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Club + Équipe
        Row(children: [
          Expanded(
            child: ClubPicker(
              onChanged: (cid) {
                setState(() => _clubId = cid);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TeamPicker(
              clubId: _clubId,
              onChanged: (tid) {
                final clubId = _clubId;
                if (clubId == null) return;
                context
                    .read<CreateEventBloc>()
                    .add(TrainingClubTeamChanged(clubId, tid));
              },
            ),
          ),
        ]),
        BlocSelector<CreateEventBloc, CreateEventState, String?>(
          selector: (s) => s.trainingClubTeamError,
          builder: (context, error) => error == null
              ? const SizedBox.shrink()
              : Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: Text(
              error,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),


        const SizedBox(height: 8),

        // Coach
        BlocSelector<CreateEventBloc, CreateEventState, String>(
          selector: (s) => s.coachId,
          builder: (context, coach) {
            return TextFormField(
              initialValue: coach,
              decoration: const InputDecoration(
                labelText: 'Coach (optionnel)',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) =>
                  context.read<CreateEventBloc>().add(CoachChanged(v)),
            );
          },
        ),
        const SizedBox(height: 8),

        // Notes
        BlocSelector<CreateEventBloc, CreateEventState, String>(
          selector: (s) => s.notes,
          builder: (context, notes) {
            return TextFormField(
              initialValue: notes,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes (optionnel)',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) =>
                  context.read<CreateEventBloc>().add(NotesChanged(v)),
            );
          },
        ),
      ],
    );
  }
}
