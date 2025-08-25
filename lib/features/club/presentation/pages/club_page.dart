import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:volleyapp/app/di/service_locator.dart';
import 'package:volleyapp/app/routing/app_route.dart';
import 'package:volleyapp/features/club/presentation/blocs/team_bloc/team_bloc.dart';
import 'package:volleyapp/features/club/presentation/blocs/team_bloc/team_event.dart';
import 'package:volleyapp/features/club/presentation/widgets/team_list.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/approve_club_join_request/approve_club_join_request_use_case.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/get_all_club_join_request_by_club_id/get_all_club_join_request_by_club_id_use_case.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/reject_club_join_request/reject_club_join_request_use_case.dart';
import 'package:volleyapp/features/club_join_request/presentation/blocs/request_model_bloc/request_modal_bloc.dart';
import 'package:volleyapp/features/club_join_request/presentation/blocs/request_model_bloc/request_modal_event.dart';
import 'package:volleyapp/features/club_join_request/presentation/widgets/RequestsBottomSheet.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/add_club_membership_use_case/add_club_membership_use_case.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/get_club_for_current_user/get_club_for_current_user_use_case.dart';
import 'package:volleyapp/features/club_team/domain/use_cases/get_all_team_by_club_id/get_all_team_by_club_id_use_case.dart';
class ClubPage extends StatelessWidget {
  const ClubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeamBloc(
        getClubForCurrentUserUseCase: locator<GetClubForCurrentUserUseCase>(),
        getAllTeamByClubId: locator<GetAllTeamByClubId>(),
      )..add(LoadMyClubTeams()), // 1er chargement
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              title: const Text("Mettre le nom du club quand clubBloc ok"),
            ),
            body: const TeamList(), // ne crée plus de BlocProvider ici
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // on attend le résultat de la page de création
                          final created = await context.push<bool>(AppRoute.team.path);
                          // si créé, on recharge
                          if (created == true && context.mounted) {
                            context.read<TeamBloc>().add(LoadMyClubTeams());
                          }
                        },
                        child: const Text('Créer une équipe'),
                      ),
                    ),
                    const SizedBox(width: 12),
                     Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (ctx) {
                              return BlocProvider(
                                create: (_) => RequestsModalBloc(
                                  getClubForCurrentUserUseCase: locator<GetClubForCurrentUserUseCase>(),
                                  getAllTeamByClubId: locator<GetAllTeamByClubId>(),
                                  getAllRequestsByClubId: locator<GetAllClubJoinRequestByClubId>(),
                                  approveClubJoinRequestUseCase: locator<ApproveClubJoinRequestUseCase>(),
                                  addClubMembershipUseCase: locator<AddClubMembershipUseCase>(),
                                  rejectClubJoinRequestUseCase: locator<RejectClubJoinRequestUseCase>(),
                                )..add(LoadRequestsModal()),
                                child: const RequestsBottomSheet(),
                              );
                            },
                          );
                        },
                        child: Text('Voir demande'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}