import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/club/domain/entities/club.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/get_all_club_join_request_by_club_id/get_all_club_join_request_by_club_id_params.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/get_all_club_join_request_by_club_id/get_all_club_join_request_by_club_id_use_case.dart';
import 'package:volleyapp/features/club_join_request/presentation/blocs/club_join_request_list_bloc/club_join_request_event.dart';
import 'package:volleyapp/features/club_join_request/presentation/blocs/club_join_request_list_bloc/club_join_request_list_state.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/get_club_for_current_user/get_club_for_current_user_use_case.dart';

class ClubJoinRequestListBloc
    extends Bloc<ClubJoinRequestListEvent, ClubJoinRequestListState> {
  final GetClubForCurrentUserUseCase _getClubForCurrentUserUseCase;
  final GetAllClubJoinRequestByClubId _getAllClubJoinRequestByClubId;

  ClubJoinRequestListBloc({
    required GetClubForCurrentUserUseCase getClubForCurrentUserUseCase,
    required GetAllClubJoinRequestByClubId getAllClubJoinRequestByClubId,
  })  : _getClubForCurrentUserUseCase = getClubForCurrentUserUseCase,
        _getAllClubJoinRequestByClubId = getAllClubJoinRequestByClubId,
        super(JoinRequestInitial()) {
    on<LoadJoinRequestList>(_onLoadJoinRequestList);
  }

  Future<void> _onLoadJoinRequestList(
      LoadJoinRequestList event,
      Emitter<ClubJoinRequestListState> emit,
      ) async {
    emit(JoinRequestLoading());

    final Either<Failure, Club> clubEither = await _getClubForCurrentUserUseCase();

    await clubEither.fold(
          (failure) async {
        emit(JoinRequestError(failure.message));
      },
          (club) async {
        final eitherRequests = await _getAllClubJoinRequestByClubId(
          GetAllClubJoinRequestByClubIdParams(club.id),
        );

        eitherRequests.fold(
              (failure) => emit(JoinRequestError(failure.message)),
              (requests) => emit(JoinRequestLoaded(requests: requests)),
        );
      },
    );
  }
}