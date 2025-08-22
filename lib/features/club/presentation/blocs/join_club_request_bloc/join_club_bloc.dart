import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/club/domain/use_cases/get_filtered_club_by_name/get_filtered_club_by_name_params.dart';
import 'package:volleyapp/features/club/domain/use_cases/get_filtered_club_by_name/get_filtered_club_by_name_use_case.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/submit_club_join_request/submit_club_join_request_params.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/submit_club_join_request/submit_club_join_request_use_case.dart';
import 'join_club_event.dart';
import 'join_club_state.dart';

class JoinClubBloc extends Bloc<JoinClubEvent, JoinClubState> {
  final GetFilteredClubByNameUseCase _getFilteredClubByNameUseCase;
  final SubmitClubJoinRequestUseCase _submitClubJoinRequestUseCase;
  final FirebaseAuth _auth;

  JoinClubBloc(GetFilteredClubByNameUseCase getFilteredClubByNameUseCase,
      SubmitClubJoinRequestUseCase submitClubJoinRequestUseCase,
      FirebaseAuth auth,
  ) :
        _getFilteredClubByNameUseCase = getFilteredClubByNameUseCase,
        _submitClubJoinRequestUseCase = submitClubJoinRequestUseCase,
        _auth = auth,
        super(const JoinClubState()) {
    on<SearchClubsChanged>(_onSearch);
    on<ClubSelected>(_onClubSelected);
    on<SubmitJoinClub>(_onSubmitJoinClub);
  }

  void _onClubSelected(ClubSelected event, Emitter<JoinClubState>emit){
   emit(state.copyWith(selected: event.club));
}

  Future<void> _onSearch(
      SearchClubsChanged event,
      Emitter<JoinClubState> emit,
      ) async {

    final query = event.query.trim();

    emit(state.copyWith(
      query: query,
      status: ClubSearchStatus.loading,
      error: null,
      resetSelected: true,
    ));

    final either = await _getFilteredClubByNameUseCase(
      GetFilteredClubByNameParams(query: query),
    );

    if (state.query != query) return;

    either.fold(
          (failure) {
        emit(state.copyWith(
          status: ClubSearchStatus.failure,
          error: _failureMessage(failure),
          results: const [],
        ));
      },
          (results) {

        if (results.isEmpty) {
          emit(state.copyWith(
            status: ClubSearchStatus.empty,
            results: const [],
            error: null,
          ));
        } else {
          emit(state.copyWith(
            status: ClubSearchStatus.success,
            results: results,
            error: null,
          ));
        }
      },
    );
  }

  Future<void> _onSubmitJoinClub(
      SubmitJoinClub event,
      Emitter<JoinClubState> emit,
      ) async {

    final user = _auth.currentUser;

    if (user == null || state.selected == null) return;

    emit(state.copyWith(isSubmitting: true, error: null, isSuccess: false));
    final result = await _submitClubJoinRequestUseCase(
      SubmitClubJoinRequestParams(
        clubId: state.selected!.id,
        userId: user.uid,
      ),
    );

    result.fold(
          (failure) {
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: false,
          error: failure.toString(),
        ));
      },
          (clubJoinRequest) {
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          error: null,
        ));
      },
    );
  }
  String _failureMessage(Failure f) {
    // Adapte si tu as des sous-classes (NetworkFailure, ServerFailure, etc.)
    // et/ou une propriété `message`. Par défaut :
    return f.toString();
  }

}