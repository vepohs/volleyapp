import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/create_club_bloc/create_club_bloc.dart';
import '../blocs/create_club_bloc/create_club_event.dart';
import '../blocs/create_club_bloc/create_club_state.dart';

class CreateClubNameField extends StatelessWidget {
  const CreateClubNameField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CreateClubBloc, CreateClubState,
        ({String name, String? error, bool submitting})>(
      selector: (s) => (name: s.clubName, error: s.clubNameError, submitting: s.isSubmitting),
      builder: (context, slice) {
        return TextFormField(
          enabled: !slice.submitting,
          initialValue: slice.name, // lu au 1er build
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Nom du club',
            hintText: 'Ex. Les Aces de Lyon',
            errorText: slice.error,
          ),
          onChanged: (value) => context.read<CreateClubBloc>().add(ClubNameChanged(value)),
        );
      },
    );
  }
}
