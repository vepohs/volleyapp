import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/core/form/states/email_state.dart';

class EmailField<TBloc extends BlocBase<TState>, TState extends EmailState>
    extends StatelessWidget {

  final void Function(String value) onChanged;

  const EmailField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TBloc, TState>(
      buildWhen: (prev, curr) =>
      prev.email != curr.email || prev.emailError != curr.emailError || prev.isSubmitting !=curr.isSubmitting,
      builder: (context, state) {
        return TextFormField(
          enabled: !state.isSubmitting,
          initialValue: state.email,
          onChanged: onChanged,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: "Adresse e-mail",
            errorText: state.emailError,
          ),
        );
      },
    );
  }
}
