import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:volleyapp/app/di/service_locator.dart';
import 'package:volleyapp/features/user/domain/use_cases/add_user/add_user_usecase.dart';
import 'package:volleyapp/features/user/presentation/blocs/add_user_bloc/add_user_bloc.dart';
import 'package:volleyapp/features/user/presentation/blocs/add_user_bloc/add_user_state.dart';
import 'package:volleyapp/features/user/presentation/widgets/avatar_url_field.dart';
import 'package:volleyapp/features/user/presentation/widgets/birthdate_field.dart';
import 'package:volleyapp/features/user/presentation/widgets/first_name_field.dart';
import 'package:volleyapp/features/user/presentation/widgets/last_name_field.dart';
import 'package:volleyapp/features/user/presentation/widgets/submit_btn.dart';

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
                  FirstNameField(),
                  SizedBox(height: 12),
                  LastNameField(),
                  SizedBox(height: 12),
                  BirthdateField(),
                  SizedBox(height: 12),
                  AvatarUrlField(),
                  SizedBox(height: 24),
                  SubmitBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}










