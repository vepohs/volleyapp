import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:volleyapp/features/event/presentation/blocs/create_event/create_event_bloc.dart';
import 'package:volleyapp/features/event/presentation/blocs/create_event/create_event_event.dart';
import 'package:volleyapp/features/event/presentation/blocs/create_event/create_event_state.dart';

import 'package:volleyapp/features/event/presentation/widgets/fields/date_time_field.dart';
import 'package:volleyapp/features/event/presentation/widgets/fields/match_fields.dart';
import 'package:volleyapp/features/event/presentation/widgets/fields/training_fields.dart';

class CreateEventSheet extends StatelessWidget {
  const CreateEventSheet({super.key});

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
    if (!context.mounted) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial ?? now),
    );
    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return BlocConsumer<CreateEventBloc, CreateEventState>(
      listenWhen: (p, c) => p.success != c.success || p.error != c.error,
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
        if (state.success == true) {
          Navigator.of(context).maybePop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Évènement créé')),
          );
        }
      },
      builder: (context, state) {
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
                  key: formKey,
                  child: Column(
                    children: [
                      // Type
                      Row(children: [
                        Expanded(
                          child: RadioListTile<CreateEventKind>(
                            value: CreateEventKind.match,
                            groupValue: state.kind,
                            title: const Text('Match'),
                            onChanged: (v) =>
                                context.read<CreateEventBloc>().add(EventKindChanged(v!)),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<CreateEventKind>(
                            value: CreateEventKind.training,
                            groupValue: state.kind,
                            title: const Text('Entraînement'),
                            onChanged: (v) =>
                                context.read<CreateEventBloc>().add(EventKindChanged(v!)),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 8),

                      // Date / Heure
                      Row(children: [
                        Expanded(
                          child: DateTimeField(
                            label: 'Début',
                            value: state.startAt,
                            errorText: state.startAtError, // 👈
                            onTap: () async {
                              final bloc = context.read<CreateEventBloc>();
                              final dt = await _pickDateTime(context, initial: state.startAt);
                              if (dt == null) return;
                              bloc.add(StartAtChanged(dt));
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DateTimeField(
                            label: 'Fin',
                            value: state.endAt,
                            errorText: state.endAtError, // 👈
                            onTap: () async {
                              final bloc = context.read<CreateEventBloc>();
                              final dt = await _pickDateTime(context, initial: state.endAt);
                              if (dt == null) return;
                              bloc.add(EndAtChanged(dt));
                            },
                          ),
                        ),
                      ]),
                      const SizedBox(height: 8),

                      // Lieu
                      TextFormField(
                        initialValue: state.location,
                        decoration: InputDecoration(
                          labelText: 'Lieu',
                          prefixIcon: const Icon(Icons.place_outlined),
                          errorText: state.locationError, // 👈
                        ),
                        onChanged: (v) =>
                            context.read<CreateEventBloc>().add(LocationChanged(v)),
                      ),

                      const SizedBox(height: 12),

                      if (state.kind == CreateEventKind.match) const MatchFields(),
                      if (state.kind == CreateEventKind.training) const TrainingFields(),

                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: state.submitting
                              ? null
                              : () {
                            formKey.currentState?.validate();
                            context.read<CreateEventBloc>().add(CreateEventSubmitted());
                          },
                          icon: state.submitting
                              ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                              : const Icon(Icons.check),
                          label: Text(state.submitting ? 'Création...' : 'Créer'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
