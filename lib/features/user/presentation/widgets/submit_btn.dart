import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/features/user/presentation/blocs/add_user_bloc/add_user_bloc.dart';
import 'package:volleyapp/features/user/presentation/blocs/add_user_bloc/add_user_event.dart';
import 'package:volleyapp/features/user/presentation/blocs/add_user_bloc/add_user_state.dart';

class SubmitBtn extends StatelessWidget {
  const SubmitBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AddUserBloc, AddUserState, ({bool submitting, String first, String last, DateTime? birth})>(
      selector: (s) => (submitting: s.isSubmitting, first: s.firstName, last: s.lastName, birth: s.birthdate),
      builder: (context, slice) {
        final disabled = slice.submitting ||
            slice.first.trim().isEmpty ||
            slice.last.trim().isEmpty ||
            slice.birth == null;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: disabled
                ? null
                : () => context.read<AddUserBloc>().add(SubmitAddUser()),
            child: slice.submitting
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Enregistrer'),
          ),
        );
      },
    );
  }
}