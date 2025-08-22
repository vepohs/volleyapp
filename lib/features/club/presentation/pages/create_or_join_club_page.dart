import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:volleyapp/app/routing/app_route.dart';
import 'package:volleyapp/features/club/domain/use_cases/add_club/add_club_use_case.dart';
import 'package:volleyapp/features/club/domain/use_cases/get_filtered_club_by_name/get_filtered_club_by_name_use_case.dart';
import 'package:volleyapp/features/club/presentation/blocs/join_club_request_bloc/join_club_bloc.dart';
import 'package:volleyapp/features/club/presentation/widgets/join_club_field.dart';
import 'package:volleyapp/features/club/presentation/widgets/join_club_btn.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/submit_club_join_request/submit_club_join_request_use_case.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/add_club_membership_use_case/add_club_membership_use_case.dart';
import '../../../../app/di/service_locator.dart';
import '../blocs/create_club_bloc/create_club_bloc.dart';
import '../blocs/create_club_bloc/create_club_state.dart';
import '../widgets/create_club_btn.dart';
import '../widgets/create_club_name_field.dart';

class CreateOrJoinClubPage extends StatelessWidget {
  const CreateOrJoinClubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CreateClubBloc>(
          create: (_) => CreateClubBloc(
            addClubUseCase: locator<AddClubUseCase>(),
            addClubMembershipUseCase: locator<AddClubMembershipUseCase>(),
            auth: locator<FirebaseAuth>(),
          ),
        ),
        BlocProvider<JoinClubBloc>(
          create: (_) => JoinClubBloc(
              locator<GetFilteredClubByNameUseCase>(),
              locator<SubmitClubJoinRequestUseCase>(),
              locator<FirebaseAuth>()
          ),
        ),
      ],
      child: const _CreateClubView(),
    );
  }
}


class _CreateClubView extends StatelessWidget {
  const _CreateClubView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateClubBloc, CreateClubState>(
      listenWhen: (prev, curr) =>
      prev.isSuccess != curr.isSuccess || prev.submitError != curr.submitError,
      listener: (context, state) {
        if (state.isSuccess == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Club créé ')),
          );
          context.go(AppRoute.home.path); // TODO
        } else if (state.submitError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.submitError!)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Créer ou rejoindre un club')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CreateClubNameField(),
                  SizedBox(height: 24),
                  CreateClubBtn(),
                  JoinClubField(),
                  JoinClubBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




