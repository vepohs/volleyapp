import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, ReadContext;
import 'package:volleyapp/features/club/presentation/blocs/join_club_request_bloc/join_club_bloc.dart';
import 'package:volleyapp/features/club/presentation/blocs/join_club_request_bloc/join_club_event.dart';
import 'package:volleyapp/features/club/presentation/blocs/join_club_request_bloc/join_club_state.dart';

class JoinClubBtn extends StatelessWidget {

  const JoinClubBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JoinClubBloc, JoinClubState>(
      buildWhen: (prev, curr) =>
      prev.selected != curr.selected ||
          prev.isSubmitting != curr.isSubmitting,
      builder: (context, state) {
        final isEnabled = state.selected != null && !state.isSubmitting;

        return ElevatedButton(
          onPressed: isEnabled
              ? () => context.read<JoinClubBloc>().add(SubmitJoinClub())
              : null,
          child: state.isSubmitting
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Rejoindre ce club'),
        );
      },
    );

  }
}
