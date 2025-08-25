import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/club/domain/entities/club.dart';
import 'package:volleyapp/features/club_join_request/domain/entities/club_join_request.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/approve_club_join_request/approve_club_join_request_params.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/approve_club_join_request/approve_club_join_request_use_case.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/get_all_club_join_request_by_club_id/get_all_club_join_request_by_club_id_params.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/get_all_club_join_request_by_club_id/get_all_club_join_request_by_club_id_use_case.dart';
import 'package:volleyapp/features/club_join_request/presentation/blocs/request_model_bloc/request_modal_event.dart';
import 'package:volleyapp/features/club_join_request/presentation/blocs/request_model_bloc/request_modal_state.dart';
import 'package:volleyapp/features/club_membership/domain/entities/role.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/get_club_for_current_user/get_club_for_current_user_use_case.dart';
import 'package:volleyapp/features/club_team/domain/use_cases/get_all_team_by_club_id/get_all_team_by_club_id_params.dart';
import 'package:volleyapp/features/club_team/domain/use_cases/get_all_team_by_club_id/get_all_team_by_club_id_use_case.dart';
import 'package:volleyapp/features/team/domain/entities/team.dart';

class RequestsModalBloc extends Bloc<RequestsModalEvent, RequestsModalState> {
  final GetClubForCurrentUserUseCase _getClubForCurrentUser;
  final GetAllTeamByClubId _getAllTeamByClubId;
  final GetAllClubJoinRequestByClubId _getAllRequestsByClubId;
  final ApproveClubJoinRequestUseCase _approveRequest;


  RequestsModalBloc({
    required GetClubForCurrentUserUseCase getClubForCurrentUserUseCase,
    required GetAllTeamByClubId getAllTeamByClubId,
    required GetAllClubJoinRequestByClubId getAllRequestsByClubId,
    required ApproveClubJoinRequestUseCase approveClubJoinRequestUseCase,
  })  : _getClubForCurrentUser = getClubForCurrentUserUseCase,
        _getAllTeamByClubId = getAllTeamByClubId,
        _getAllRequestsByClubId = getAllRequestsByClubId,
        _approveRequest = approveClubJoinRequestUseCase,

      super(RequestsModalInitial()) {
      on<LoadRequestsModal>(_onLoad);
      on<ApproveRequestPressed>(_onApprove);

  }

  Future<void> _onLoad(
      LoadRequestsModal event,
      Emitter<RequestsModalState> emit,
      ) async {
    emit(RequestsModalLoading());

    final Either<Failure, Club> clubEither = await _getClubForCurrentUser();
    await clubEither.fold(
          (f) async => emit(RequestsModalError(f.message)),
          (club) async {
        final teamsEither =
        await _getAllTeamByClubId(GetAllTeamByClubIdParams(clubId: club.id));
        final requestsEither = await _getAllRequestsByClubId(
          GetAllClubJoinRequestByClubIdParams(club.id),
        );



        if (teamsEither.isLeft()) {
          emit(RequestsModalError(
              teamsEither.swap().getOrElse(() => Failure('Erreur équipes')).message));
          return;
        }
        if (requestsEither.isLeft()) {
          emit(RequestsModalError(
              requestsEither.swap().getOrElse(() => Failure('Erreur demandes')).message));
          return;
        }

        final teams = teamsEither.getOrElse(() => <Team>[]);
        final requests = requestsEither.getOrElse(() => <ClubJoinRequest>[]);

        emit(RequestsModalLoaded(club: club, teams: teams, requests: requests));
      },
    );
  }

  Future<void> _onApprove(
      ApproveRequestPressed event,
      Emitter<RequestsModalState> emit,
      ) async {
    emit(RequestsModalLoading());
    final result =
    await _approveRequest(ApproveClubJoinRequestParams(requestId: event.requestId));

    await result.fold(
          (failure) async => emit(RequestsModalError(failure.message)),
          (_) async {
        add(LoadRequestsModal());
      },
    );
  }
}

