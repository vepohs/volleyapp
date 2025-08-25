import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/features/event/presentation/blocs/create_event/create_event_bloc.dart';
import 'package:volleyapp/features/event/presentation/blocs/create_event/create_event_event.dart';
import 'package:volleyapp/features/event/presentation/blocs/create_event/create_event_state.dart';
import 'package:volleyapp/features/event/presentation/widgets/pickers/club_picker.dart';
import 'package:volleyapp/features/event/presentation/widgets/pickers/team_picker.dart';

class MatchFields extends StatelessWidget {
  const MatchFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Domicile
        const _ClubTeamRow(
          title: 'Domicile',
          isHome: true,
        ),
        BlocSelector<CreateEventBloc, CreateEventState, String?>(
          selector: (s) => s.homeClubTeamError,
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

        // Extérieur
        const _ClubTeamRow(
          title: 'Extérieur',
          isHome: false,
        ),
        BlocSelector<CreateEventBloc, CreateEventState, String?>(
          selector: (s) => s.homeClubTeamError,
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

        // Compétition
        BlocSelector<CreateEventBloc, CreateEventState, String>(
          selector: (s) => s.competition,
          builder: (context, competition) {
            return TextFormField(
              initialValue: competition,
              decoration: const InputDecoration(
                labelText: 'Compétition (optionnel)',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) =>
                  context.read<CreateEventBloc>().add(CompetitionChanged(v)),
            );
          },
        ),
      ],
    );
  }
}

class _ClubTeamRow extends StatefulWidget {
  final String title;
  final bool isHome; // true => home, false => away
  const _ClubTeamRow({required this.title, required this.isHome});

  @override
  State<_ClubTeamRow> createState() => _ClubTeamRowState();
}

class _ClubTeamRowState extends State<_ClubTeamRow> {
  String? _clubId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(widget.title, style: Theme.of(context).textTheme.labelLarge),
        ),
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
                final bloc = context.read<CreateEventBloc>();
                if (widget.isHome) {
                  bloc.add(HomeClubTeamChanged(clubId, tid));
                } else {
                  bloc.add(AwayClubTeamChanged(clubId, tid));
                }
              },
            ),
          ),
        ]),
      ],
    );
  }
}
