import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/features/user/presentation/blocs/add_user_bloc/add_user_bloc.dart';
import 'package:volleyapp/features/user/presentation/blocs/add_user_bloc/add_user_event.dart';
import 'package:volleyapp/features/user/presentation/blocs/add_user_bloc/add_user_state.dart';

class AvatarUrlField extends StatelessWidget {
  const AvatarUrlField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AddUserBloc, AddUserState, ({String? value, String? error, bool submitting})>(
      selector: (s) => (value: s.avatarUrl, error: s.avatarUrlError, submitting: s.isSubmitting),
      builder: (_, slice) {
        return TextFormField(
          enabled: !slice.submitting,
          initialValue: slice.value ?? '',
          decoration: InputDecoration(
            labelText: 'URL de l’avatar (optionnel)',
            errorText: slice.error,
          ),
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.done,
          onChanged: (v) => context.read<AddUserBloc>().add(AvatarChanged(v)),
        );
      },
    );
  }
}