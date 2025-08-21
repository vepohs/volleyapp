import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/features/user/presentation/blocs/add_user_bloc/add_user_bloc.dart';
import 'package:volleyapp/features/user/presentation/blocs/add_user_bloc/add_user_event.dart';
import 'package:volleyapp/features/user/presentation/blocs/add_user_bloc/add_user_state.dart';

class FirstNameField extends StatelessWidget {
  const FirstNameField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AddUserBloc, AddUserState, ({String value, String? error, bool submitting})>(
      selector: (s) => (value: s.firstName, error: s.firstNameError, submitting: s.isSubmitting),
      builder: (_, slice) {
        return TextFormField(
          enabled: !slice.submitting,
          initialValue: slice.value,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Prénom',
            errorText: slice.error,
          ),
          onChanged: (v) => context.read<AddUserBloc>().add(FirstnameChanged(v)),
        );
      },
    );
  }
}