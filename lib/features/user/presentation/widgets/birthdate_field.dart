import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/features/user/presentation/blocs/add_user_bloc/add_user_bloc.dart';
import 'package:volleyapp/features/user/presentation/blocs/add_user_bloc/add_user_event.dart';
import 'package:volleyapp/features/user/presentation/blocs/add_user_bloc/add_user_state.dart';

class BirthdateField extends StatelessWidget {
  const BirthdateField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AddUserBloc, AddUserState, ({DateTime? value, String? error, bool submitting})>(
      selector: (s) => (value: s.birthdate, error: s.birthdateError, submitting: s.isSubmitting),
      builder: (context, slice) {
        final text = slice.value != null
            ? '${slice.value!.day.toString().padLeft(2, '0')}/${slice.value!.month.toString().padLeft(2, '0')}/${slice.value!.year}'
            : 'Sélectionner une date';
        return InkWell(
          onTap: slice.submitting
              ? null
              : () async {
            final now = DateTime.now();
            final initial = slice.value ?? DateTime(now.year - 18, now.month, now.day);
            final picked = await showDatePicker(
              context: context,
              initialDate: initial,
              firstDate: DateTime(1900),
              lastDate: now,
            );
            if (picked != null) {
              context.read<AddUserBloc>().add(BirthdateChanged(picked));
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Date de naissance',
              errorText: slice.error,
              enabled: !slice.submitting,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            child: Text(text),
          ),
        );
      },
    );
  }
}