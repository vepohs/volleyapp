import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:volleyapp/app/di/service_locator.dart';
import 'package:volleyapp/features/user/domain/use_cases/add_user/add_user_usecase.dart';
import 'package:volleyapp/features/user/presentation/blocs/add_user_bloc/add_user_bloc.dart';
import 'package:volleyapp/features/user/presentation/blocs/add_user_bloc/add_user_event.dart';
import 'package:volleyapp/features/user/presentation/blocs/add_user_bloc/add_user_state.dart';

class AddUserPage extends StatelessWidget {
  const AddUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddUserBloc(
        auth: locator<FirebaseAuth>(),
        addUserUseCase : locator<AddUserUseCase>(),
      ),
      child: const _AddUserView(),
    );
  }
}

class _AddUserView extends StatelessWidget {
  const _AddUserView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddUserBloc, AddUserState>(
      listenWhen: (p, c) => p.isSuccess != c.isSuccess,
      listener: (context, state) {
        if (state.isSuccess == true) {
          // à adapter: route de destination après succès
          context.go('/home');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil enregistré ✅')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Compléter mon profil')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  _FirstNameField(),
                  SizedBox(height: 12),
                  _LastNameField(),
                  SizedBox(height: 12),
                  _BirthdateField(),
                  SizedBox(height: 12),
                  _AvatarUrlField(),
                  SizedBox(height: 24),
                  _SubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Prénom
class _FirstNameField extends StatelessWidget {
  const _FirstNameField();

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

/// Nom
class _LastNameField extends StatelessWidget {
  const _LastNameField();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AddUserBloc, AddUserState, ({String value, String? error, bool submitting})>(
      selector: (s) => (value: s.lastName, error: s.lastNameError, submitting: s.isSubmitting),
      builder: (_, slice) {
        return TextFormField(
          enabled: !slice.submitting,
          initialValue: slice.value,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Nom',
            errorText: slice.error,
          ),
          onChanged: (v) => context.read<AddUserBloc>().add(LastnameChanged(v)),
        );
      },
    );
  }
}

/// Date de naissance (avec date picker)
class _BirthdateField extends StatelessWidget {
  const _BirthdateField();

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

/// URL avatar (optionnel)
class _AvatarUrlField extends StatelessWidget {
  const _AvatarUrlField();

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

/// Bouton Enregistrer
class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

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
