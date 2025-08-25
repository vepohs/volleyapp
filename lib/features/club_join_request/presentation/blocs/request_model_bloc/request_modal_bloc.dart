import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/club/domain/entities/club.dart';
import 'package:volleyapp/features/club_join_request/domain/entities/club_join_request.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/approve_club_join_request/approve_club_join_request_params.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/approve_club_join_request/approve_club_join_request_use_case.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/get_all_club_join_request_by_club_id/get_all_club_join_request_by_club_id_params.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/get_all_club_join_request_by_club_id/get_all_club_join_request_by_club_id_use_case.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/reject_club_join_request/reject_club_join_request_params.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/reject_club_join_request/reject_club_join_request_use_case.dart';
import 'package:volleyapp/features/club_join_request/presentation/blocs/request_model_bloc/request_modal_event.dart';
import 'package:volleyapp/features/club_join_request/presentation/blocs/request_model_bloc/request_modal_state.dart';
import 'package:volleyapp/features/club_membership/domain/entities/role.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/add_club_membership_use_case/add_club_membership_use_case.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/add_club_membership_use_case/add_club_memership_params.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/get_club_for_current_user/get_club_for_current_user_use_case.dart';
import 'package:volleyapp/features/club_team/domain/use_cases/get_all_team_by_club_id/get_all_team_by_club_id_params.dart';
import 'package:volleyapp/features/club_team/domain/use_cases/get_all_team_by_club_id/get_all_team_by_club_id_use_case.dart';
import 'package:volleyapp/features/team/domain/entities/team.dart';

class RequestsModalBloc extends Bloc<RequestsModalEvent, RequestsModalState> {
  final GetClubForCurrentUserUseCase _getClubForCurrentUser;
  final GetAllTeamByClubId _getAllTeamByClubId;
  final GetAllClubJoinRequestByClubId _getAllRequestsByClubId;
  final ApproveClubJoinRequestUseCase _approveRequest;
  final AddClubMembershipUseCase _addMembership;
  final RejectClubJoinRequestUseCase _rejectRequest;


  RequestsModalBloc({
    required GetClubForCurrentUserUseCase getClubForCurrentUserUseCase,
    required GetAllTeamByClubId getAllTeamByClubId,
    required GetAllClubJoinRequestByClubId getAllRequestsByClubId,
    required ApproveClubJoinRequestUseCase approveClubJoinRequestUseCase,
    required AddClubMembershipUseCase addClubMembershipUseCase,
    required RejectClubJoinRequestUseCase rejectClubJoinRequestUseCase,
  })  : _getClubForCurrentUser = getClubForCurrentUserUseCase,
        _getAllTeamByClubId = getAllTeamByClubId,
        _getAllRequestsByClubId = getAllRequestsByClubId,
        _approveRequest = approveClubJoinRequestUseCase,
        _addMembership = addClubMembershipUseCase,
        _rejectRequest = rejectClubJoinRequestUseCase,

      super(RequestsModalInitial()) {
      on<LoadRequestsModal>(_onLoad);
      on<TeamSelectionChanged>(_onTeamSelectionChanged);
      on<ApproveRequestPressed>(_onApprove);
      on<RoleSelectionChanged>(_onRoleSelectionChanged);
      on<RejectRequestPressed>(_onReject);
  }

  Future<void> _onLoad(
      LoadRequestsModal event,
      Emitter<RequestsModalState> emit,
      ) async {
    emit(RequestsModalLoading());
    final clubEither = await _getClubForCurrentUser();

    await clubEither.fold(
          (f) async => emit(RequestsModalError(f.message)),
          (club) async {
        final teamsEither = await _getAllTeamByClubId(GetAllTeamByClubIdParams(clubId: club.id));
        final requestsEither = await _getAllRequestsByClubId(GetAllClubJoinRequestByClubIdParams(club.id));

        if (teamsEither.isLeft()) {
          emit(RequestsModalError(teamsEither.swap().getOrElse(() => Failure('Erreur équipes')).message));
          return;
        }
        if (requestsEither.isLeft()) {
          emit(RequestsModalError(requestsEither.swap().getOrElse(() => Failure('Erreur demandes')).message));
          return;
        }

        final teams = teamsEither.getOrElse(() => <Team>[]);
        final requests = requestsEither.getOrElse(() => <ClubJoinRequest>[]);

        // Préserver sélections existantes si reload
        Map<String, String?> prevTeams = {};
        Map<String, String?> prevRoles = {};
        final current = state;
        if (current is RequestsModalLoaded) {
          prevTeams = Map.of(current.selectedTeamByRequest);
          prevRoles = Map.of(current.selectedRoleByRequest);
        }

        final selectedTeamMap = { for (final req in requests) req.id: prevTeams[req.id] };
        final selectedRoleMap = { for (final req in requests) req.id: prevRoles[req.id] };

        emit(RequestsModalLoaded(
          club: club,
          teams: teams,
          requests: requests,
          selectedTeamByRequest: selectedTeamMap,
          selectedRoleByRequest: selectedRoleMap, // NEW
        ));
      },
    );
  }

  Future<void> _onTeamSelectionChanged(
      TeamSelectionChanged event,
      Emitter<RequestsModalState> emit,
      ) async {
    final current = state;
    if (current is! RequestsModalLoaded) return;

    final updated = Map<String, String?>.from(current.selectedTeamByRequest);
    updated[event.requestId] = event.teamId;

    emit(current.copyWith(selectedTeamByRequest: updated));
  }

  Future<void> _onRoleSelectionChanged(
      RoleSelectionChanged event,
      Emitter<RequestsModalState> emit,
      ) async {
    final current = state;
    if (current is! RequestsModalLoaded) return;

    final updated = Map<String, String?>.from(current.selectedRoleByRequest);
    updated[event.requestId] = event.roleId;

    emit(current.copyWith(selectedRoleByRequest: updated));
  }

  Future<void> _onApprove(
      ApproveRequestPressed event,
      Emitter<RequestsModalState> emit,
      ) async {
    final current = state;
    if (current is! RequestsModalLoaded) return;

    // 1) Récupérer les sélections pour cette demande
    final String? selectedTeamId = current.selectedTeamByRequest[event.requestId];
    final String? selectedRoleId = current.selectedRoleByRequest[event.requestId];

    if (selectedTeamId == null || selectedRoleId == null) {
      emit(RequestsModalError("Sélectionne une équipe et un rôle avant d'accepter."));
      return;
    }

    // 2) Retrouver la demande et les infos nécessaires
    final req = current.requests.firstWhere(
          (r) => r.id == event.requestId,
      orElse: () => throw StateError("Demande introuvable dans l'état."),
    );

    // Selon ton modèle, adapte la récupération du userId.
    // Tu as affiché r.user.firstname/lastname en UI, donc on suppose r.user.id existe.
    final String userId = (req.user.id);
    final String clubId = current.club.id;
    final role = Role.fromId(selectedRoleId);

    emit(RequestsModalLoading());

    // 3) Ajouter le user comme membre du club AVANT d'approuver la demande.
    // (si cet ajout échoue, on n'approuve pas la demande pour ne pas créer d'incohérence)
    final membershipEither = await _addMembership(
      AddClubMembershipParams(
        clubId: clubId,
        userId: userId,
        role: role,
      ),
    );

    final membershipOk = await membershipEither.fold(
          (failure) async {
        emit(RequestsModalError(failure.message));
        return false;
      },
          (_) async => true,
    );
    if (!membershipOk) return;

    // 4) Approuver la demande
    final approveEither =
    await _approveRequest(ApproveClubJoinRequestParams(requestId: event.requestId));

    await approveEither.fold(
          (failure) async => emit(RequestsModalError(failure.message)),
          (_) async {
        // 5) Recharger la liste (préserve les sélections existantes dans _onLoad)
        add(LoadRequestsModal());
      },
    );
  }


  Future<void> _onReject(
      RejectRequestPressed event,
      Emitter<RequestsModalState> emit,
      ) async {
    emit(RequestsModalLoading());

    final either = await _rejectRequest(
      RejectClubJoinRequestParams(requestId: event.requestId)
    );

    await either.fold(
          (failure) async => emit(RequestsModalError(failure.message)),
          (_) async {
        // Optionnel : nettoyer les sélections pour cette demande dans l'état courant
        // mais comme on recharge, pas nécessaire.
        add(LoadRequestsModal());
      },
    );
  }
}

