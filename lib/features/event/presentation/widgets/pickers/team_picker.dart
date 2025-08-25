import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/app/di/service_locator.dart';
import 'package:volleyapp/features/club_team/domain/use_cases/get_all_team_by_club_id/get_all_team_by_club_id_use_case.dart';
import 'package:volleyapp/features/event/presentation/blocs/team_picker/team_picker_bloc.dart';
import 'package:volleyapp/features/event/presentation/blocs/team_picker/team_picker_event.dart';
import 'package:volleyapp/features/event/presentation/blocs/team_picker/team_picker_state.dart';

class TeamPicker extends StatefulWidget {
  final String? clubId;
  final String? initialValue;
  final void Function(String teamId)? onChanged;

  const TeamPicker({super.key, this.clubId, this.initialValue, this.onChanged});

  @override
  State<TeamPicker> createState() => _TeamPickerState();
}

class _TeamPickerState extends State<TeamPicker> {
  late final TeamPickerBloc _bloc = TeamPickerBloc(
    getTeamsByClub: locator<GetAllTeamByClubId>(),
  );

  @override
  void initState() {
    super.initState();
    if (widget.clubId != null) {
      _bloc.add(TeamPickerLoadForClub(widget.clubId!));
      if (widget.initialValue != null) {
        _bloc.add(TeamSelected(widget.initialValue!));
      }
    }
  }

  @override
  void didUpdateWidget(covariant TeamPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.clubId != widget.clubId && widget.clubId != null) {
      _bloc.add(TeamPickerLoadForClub(widget.clubId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<TeamPickerBloc, TeamPickerState>(
        builder: (context, state) {
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
                onChanged: (widget.clubId == null || state.loading)
                    ? null
                    : (id) {
                        context.read<TeamPickerBloc>().add(TeamSelected(id!));
                        widget.onChanged?.call(id);
                      },
              ),
            ),
          );
        },
      ),
    );
  }
}
