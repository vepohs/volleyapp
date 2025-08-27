import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/app/di/service_locator.dart';
import 'package:volleyapp/features/club_team/domain/use_cases/get_all_team_by_club_id/get_all_team_by_club_id_use_case.dart';
import 'package:volleyapp/features/event/presentation/blocs/team_picker/team_picker_bloc.dart';
import 'package:volleyapp/features/event/presentation/blocs/team_picker/team_picker_event.dart';
import 'package:volleyapp/features/event/presentation/blocs/team_picker/team_picker_state.dart';

class TeamPicker extends StatelessWidget {
  final String? clubId;
  final String? initialValue;
  final void Function(String teamId)? onChanged;

  const TeamPicker({
    super.key,
    this.clubId,
    this.initialValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: ValueKey(clubId),
      child: BlocProvider(
        create: (_) {
          final bloc = TeamPickerBloc(getTeamsByClub: locator<GetAllTeamByClubId>());
          if (clubId != null) {
            bloc.add(TeamPickerLoadForClub(clubId!));
            if (initialValue != null) {
              bloc.add(TeamSelected(initialValue!));
            }
          }
          return bloc;
        },
        child: BlocBuilder<TeamPickerBloc, TeamPickerState>(
          builder: (context, state) {
            final disabled = clubId == null || state.loading;
            return InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Équipe',
                border: OutlineInputBorder(),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: state.selectedTeamId,
                  hint: const Text('Sélectionner une équipe'),
                  items: [
                    for (final t in state.teams)
                      DropdownMenuItem(value: t.id, child: Text(t.name)),
                  ],
                  onChanged: disabled
                      ? null
                      : (id) {
                    if (id == null) return;
                    context.read<TeamPickerBloc>().add(TeamSelected(id));
                    onChanged?.call(id);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
