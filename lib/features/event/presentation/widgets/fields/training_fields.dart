import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/features/event/presentation/blocs/create_event/create_event_bloc.dart';
import 'package:volleyapp/features/event/presentation/blocs/create_event/create_event_event.dart';
import 'package:volleyapp/features/event/presentation/blocs/create_event/create_event_state.dart';
import 'package:volleyapp/features/event/presentation/widgets/pickers/club_picker.dart';
import 'package:volleyapp/features/event/presentation/widgets/pickers/team_picker.dart';

class TrainingFields extends StatelessWidget {
  const TrainingFields({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventBloc, CreateEventState>(
      buildWhen: (p, c) =>
      p.trainingClubId != c.trainingClubId || p.trainingTeamId != c.trainingTeamId || p.coachId != c.coachId || p.notes != c.notes,
      builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ClubPicker(
                    initialValue: state.trainingClubId,
                    onChanged: (cid) {
                      // reset team dans le bloc
                      context.read<CreateEventBloc>().add(TrainingClubChanged(cid));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TeamPicker(
                    clubId: state.trainingClubId,
                    initialValue: state.trainingTeamId,
                    onChanged: (tid) => context.read<CreateEventBloc>().add(TrainingTeamChanged(tid)),
                  ),
                ),
              ],
            ),
            BlocSelector<CreateEventBloc, CreateEventState, String?>(
              selector: (s) => s.trainingClubTeamError,
              builder: (context, error) => error == null
                  ? const SizedBox.shrink()
                  : Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                child: Text(error, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: state.coachId,
              decoration: const InputDecoration(
                labelText: 'Coach (optionnel)',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => context.read<CreateEventBloc>().add(CoachChanged(v)),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: state.notes,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes (optionnel)',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => context.read<CreateEventBloc>().add(NotesChanged(v)),
            ),
          ],
        );
      },
    );
  }
}
