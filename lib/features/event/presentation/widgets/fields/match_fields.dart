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
        _ClubTeamRow(title: 'Domicile', isHome: true),
        BlocSelector<CreateEventBloc, CreateEventState, String?>(
          selector: (s) => s.homeClubTeamError,
          builder: (context, error) => error == null
              ? const SizedBox.shrink()
              : Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: Text(error, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ),
        const SizedBox(height: 8),
        _ClubTeamRow(title: 'Extérieur', isHome: false),
        BlocSelector<CreateEventBloc, CreateEventState, String?>(
          selector: (s) => s.awayClubTeamError,
          builder: (context, error) => error == null
              ? const SizedBox.shrink()
              : Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: Text(error, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ),
        const SizedBox(height: 8),
        BlocSelector<CreateEventBloc, CreateEventState, String>(
          selector: (s) => s.competition,
          builder: (context, competition) {
            return TextFormField(
              initialValue: competition,
              decoration: const InputDecoration(
                labelText: 'Compétition (optionnel)',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => context.read<CreateEventBloc>().add(CompetitionChanged(v)),
            );
          },
        ),
      ],
    );
  }
}

class _ClubTeamRow extends StatelessWidget {
  final String title;
  final bool isHome;
  const _ClubTeamRow({required this.title, required this.isHome});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventBloc, CreateEventState>(
      buildWhen: (p, c) => isHome
          ? (p.homeClubId != c.homeClubId || p.homeTeamId != c.homeTeamId)
          : (p.awayClubId != c.awayClubId || p.awayTeamId != c.awayTeamId),
      builder: (context, state) {
        final clubId = isHome ? state.homeClubId : state.awayClubId;
        final teamId = isHome ? state.homeTeamId : state.awayTeamId;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(title, style: Theme.of(context).textTheme.labelLarge),
            ),
            Row(
              children: [
                Expanded(
                  child: ClubPicker(
                    initialValue: clubId,
                    onChanged: (cid) {
                      final bloc = context.read<CreateEventBloc>();
                      if (isHome) {
                        bloc.add(HomeClubChanged(cid)); // reset team fait dans le bloc
                      } else {
                        bloc.add(AwayClubChanged(cid));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TeamPicker(
                    clubId: clubId,          // charge les équipes du club choisi
                    initialValue: teamId,    // re-sélection si dispo
                    onChanged: (tid) {
                      final bloc = context.read<CreateEventBloc>();
                      if (isHome) {
                        bloc.add(HomeTeamChanged(tid));
                      } else {
                        bloc.add(AwayTeamChanged(tid));
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
