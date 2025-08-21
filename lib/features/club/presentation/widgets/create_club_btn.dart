import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/create_club_bloc/create_club_bloc.dart';
import '../blocs/create_club_bloc/create_club_event.dart';
import '../blocs/create_club_bloc/create_club_state.dart';

class CreateClubBtn extends StatelessWidget {
  const CreateClubBtn();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CreateClubBloc, CreateClubState,
        ({bool submitting, String name, String? error})>(
      selector: (s) => (submitting: s.isSubmitting, name: s.clubName, error: s.clubNameError),
      builder: (context, slice) {
        final isEmpty = slice.name.trim().isEmpty;
        final hasError = slice.error != null;
        final disabled = slice.submitting || isEmpty || hasError;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: disabled
                ? null
                : () => context.read<CreateClubBloc>().add(SubmitCreateClub()),
            child: slice.submitting
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Créer le club'),
          ),
        );
      },
    );
  }
}