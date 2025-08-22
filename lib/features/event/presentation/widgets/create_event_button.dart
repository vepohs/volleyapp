import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:volleyapp/features/event/presentation/blocs/add_event_bloc.dart';
import 'package:volleyapp/features/event/presentation/blocs/add_event_event.dart';
import 'package:volleyapp/features/event/presentation/blocs/add_event_state.dart';

import 'package:volleyapp/features/event/domain/use_cases/add_event/add_event_params.dart';
import 'package:volleyapp/features/event/domain/entities/event_details.dart';
import 'package:volleyapp/features/event/domain/entities/match_details.dart';
import 'package:volleyapp/features/event/domain/entities/training_details.dart';

class CreateEventButton extends StatelessWidget {
  const CreateEventButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddEventBloc, AddEventState>(
      listenWhen: (prev, cur) => cur is AddEventSuccess || cur is AddEventFailure,
      listener: (context, state) {
        if (state is AddEventSuccess) {
          Navigator.of(context).maybePop(); // ferme la modal si ouverte
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Évènement créé')),
          );
        } else if (state is AddEventFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: FloatingActionButton.extended(
        onPressed: () => _openSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Nouvel évènement'),
      ),
    );
  }

  void _openSheet(BuildContext context) {
    final addEventBloc = context.read<AddEventBloc>(); // récupère le bloc ancêtre

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      // important: on re-provide le même bloc à la sheet
      builder: (sheetCtx) => BlocProvider.value(
        value: addEventBloc,
        child: const _CreateEventSheet(),
      ),
    );
  }

}

enum _EventType { match, training }

class _CreateEventSheet extends StatefulWidget {
  const _CreateEventSheet();

  @override
  State<_CreateEventSheet> createState() => _CreateEventSheetState();
}

class _CreateEventSheetState extends State<_CreateEventSheet> {
  final _formKey = GlobalKey<FormState>();

  _EventType _type = _EventType.match;

  DateTime? _startAt;
  DateTime? _endAt;
  final _locationCtrl = TextEditingController();

  // match fields
  final _homeClubCtrl = TextEditingController();
  final _homeTeamCtrl = TextEditingController();
  final _awayClubCtrl = TextEditingController();
  final _awayTeamCtrl = TextEditingController();
  final _competitionCtrl = TextEditingController();

  // training fields
  final _clubCtrl = TextEditingController();
  final _teamCtrl = TextEditingController();
  final _coachCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _locationCtrl.dispose();
    _homeClubCtrl.dispose();
    _homeTeamCtrl.dispose();
    _awayClubCtrl.dispose();
    _awayTeamCtrl.dispose();
    _competitionCtrl.dispose();
    _clubCtrl.dispose();
    _teamCtrl.dispose();
    _coachCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Créer un évènement', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Type
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<_EventType>(
                          value: _EventType.match,
                          groupValue: _type,
                          title: const Text('Match'),
                          onChanged: (v) => setState(() => _type = v!),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<_EventType>(
                          value: _EventType.training,
                          groupValue: _type,
                          title: const Text('Entraînement'),
                          onChanged: (v) => setState(() => _type = v!),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Date/Heure
                  Row(
                    children: [
                      Expanded(
                        child: _DateTimeField(
                          label: 'Début',
                          value: _startAt,
                          onTap: () async {
                            final dt = await _pickDateTime(context, initial: _startAt);
                            if (dt != null) setState(() => _startAt = dt);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DateTimeField(
                          label: 'Fin',
                          value: _endAt,
                          onTap: () async {
                            final dt = await _pickDateTime(context, initial: _endAt);
                            if (dt != null) setState(() => _endAt = dt);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Lieu
                  TextFormField(
                    controller: _locationCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Lieu',
                      prefixIcon: Icon(Icons.place_outlined),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Lieu requis' : null,
                  ),
                  const SizedBox(height: 12),

                  if (_type == _EventType.match) _MatchFields(
                    homeClubCtrl: _homeClubCtrl,
                    homeTeamCtrl: _homeTeamCtrl,
                    awayClubCtrl: _awayClubCtrl,
                    awayTeamCtrl: _awayTeamCtrl,
                    competitionCtrl: _competitionCtrl,
                  ),

                  if (_type == _EventType.training) _TrainingFields(
                    clubCtrl: _clubCtrl,
                    teamCtrl: _teamCtrl,
                    coachCtrl: _coachCtrl,
                    notesCtrl: _notesCtrl,
                  ),

                  const SizedBox(height: 16),
                  BlocBuilder<AddEventBloc, AddEventState>(
                    builder: (context, state) {
                      final loading = state is AddEventSubmitting;
                      return SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: loading ? null : () => _submit(context),
                          icon: loading
                              ? const SizedBox(
                            height: 18, width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                              : const Icon(Icons.check),
                          label: Text(loading ? 'Création...' : 'Créer'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    if (_startAt == null || _endAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sélectionne début et fin')),
      );
      return;
    }
    if (!_endAt!.isAfter(_startAt!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La fin doit être après le début')),
      );
      return;
    }

    late final EventDetails details;
    if (_type == _EventType.match) {
      details = MatchDetails(
        homeClubId: _homeClubCtrl.text.trim(),
        homeTeamId: _homeTeamCtrl.text.trim(),
        awayClubId: _awayClubCtrl.text.trim(),
        awayTeamId: _awayTeamCtrl.text.trim(),
        competition: _competitionCtrl.text.trim().isEmpty ? null : _competitionCtrl.text.trim(),
      );
    } else {
      details = TrainingDetails(
        clubId: _clubCtrl.text.trim(),
        teamId: _teamCtrl.text.trim(),
        coachId: _coachCtrl.text.trim().isEmpty ? null : _coachCtrl.text.trim(),
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      );
    }

    final params = AddEventParams(
      startAt: _startAt!,
      endAt: _endAt!,
      location: _locationCtrl.text.trim(),
      details: details,
    );

    context.read<AddEventBloc>().add(AddEventSubmitted(params));
  }

  Future<DateTime?> _pickDateTime(BuildContext context, {DateTime? initial}) async {
    final now = DateTime.now();
    final initDate = initial ?? now;
    final date = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );
    if (date == null) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial ?? now),
    );
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}

class _DateTimeField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  const _DateTimeField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  String _two(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final txt = (value == null)
        ? 'Sélectionner'
        : "${_two(value!.day)}/${_two(value!.month)}/${value!.year} • ${_two(value!.hour)}:${_two(value!.minute)}";
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.schedule_outlined),
          border: const OutlineInputBorder(),
        ),
        child: Text(txt),
      ),
    );
  }
}

class _MatchFields extends StatelessWidget {
  final TextEditingController homeClubCtrl;
  final TextEditingController homeTeamCtrl;
  final TextEditingController awayClubCtrl;
  final TextEditingController awayTeamCtrl;
  final TextEditingController competitionCtrl;

  const _MatchFields({
    required this.homeClubCtrl,
    required this.homeTeamCtrl,
    required this.awayClubCtrl,
    required this.awayTeamCtrl,
    required this.competitionCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Expanded(child: TextFormField(
            controller: homeClubCtrl,
            decoration: const InputDecoration(labelText: 'Club domicile', border: OutlineInputBorder()),
            validator: (v) => (v==null || v.trim().isEmpty) ? 'Requis' : null,
          )),
          const SizedBox(width: 12),
          Expanded(child: TextFormField(
            controller: homeTeamCtrl,
            decoration: const InputDecoration(labelText: 'Équipe domicile', border: OutlineInputBorder()),
            validator: (v) => (v==null || v.trim().isEmpty) ? 'Requis' : null,
          )),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: TextFormField(
            controller: awayClubCtrl,
            decoration: const InputDecoration(labelText: 'Club extérieur', border: OutlineInputBorder()),
            validator: (v) => (v==null || v.trim().isEmpty) ? 'Requis' : null,
          )),
          const SizedBox(width: 12),
          Expanded(child: TextFormField(
            controller: awayTeamCtrl,
            decoration: const InputDecoration(labelText: 'Équipe extérieure', border: OutlineInputBorder()),
            validator: (v) => (v==null || v.trim().isEmpty) ? 'Requis' : null,
          )),
        ]),
        const SizedBox(height: 8),
        TextFormField(
          controller: competitionCtrl,
          decoration: const InputDecoration(
            labelText: 'Compétition (optionnel)',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

class _TrainingFields extends StatelessWidget {
  final TextEditingController clubCtrl;
  final TextEditingController teamCtrl;
  final TextEditingController coachCtrl;
  final TextEditingController notesCtrl;

  const _TrainingFields({
    required this.clubCtrl,
    required this.teamCtrl,
    required this.coachCtrl,
    required this.notesCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Expanded(child: TextFormField(
            controller: clubCtrl,
            decoration: const InputDecoration(labelText: 'Club', border: OutlineInputBorder()),
            validator: (v) => (v==null || v.trim().isEmpty) ? 'Requis' : null,
          )),
          const SizedBox(width: 12),
          Expanded(child: TextFormField(
            controller: teamCtrl,
            decoration: const InputDecoration(labelText: 'Équipe', border: OutlineInputBorder()),
            validator: (v) => (v==null || v.trim().isEmpty) ? 'Requis' : null,
          )),
        ]),
        const SizedBox(height: 8),
        TextFormField(
          controller: coachCtrl,
          decoration: const InputDecoration(
            labelText: 'Coach (optionnel)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: notesCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Notes (optionnel)',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
