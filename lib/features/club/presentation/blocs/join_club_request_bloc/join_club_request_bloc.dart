import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/club/domain/use_cases/get_filtered_club_by_name/get_filtered_club_by_name_params.dart';
import 'package:volleyapp/features/club/domain/use_cases/get_filtered_club_by_name/get_filtered_club_by_name_use_case.dart';
import 'join_club_request_event.dart';
import 'join_club_request_state.dart';

class ClubSearchBloc extends Bloc<ClubEvent, ClubSearchState> {
  final GetFilteredClubByNameUseCase _getFilteredClubByNameUseCase;

  ClubSearchBloc(GetFilteredClubByNameUseCase getFilteredClubByNameUseCase) :
        _getFilteredClubByNameUseCase = getFilteredClubByNameUseCase,
        super(const ClubSearchState()) {
    on<SearchClubsChanged>(_onSearch);
    on<ClubSelected>((e, emit) => emit(state.copyWith(selected: e.club)));
  }

  Future<void> _onSearch(
      SearchClubsChanged event,
      Emitter<ClubSearchState> emit,
      ) async {

    final query = event.query.trim();

    emit(state.copyWith(
      query: query,
      status: ClubSearchStatus.loading,
      error: null,
      selected: null,
    ));

    final either = await _getFilteredClubByNameUseCase(
      GetFilteredClubByNameParams(query: query),
    );

    // 4) Anti-race : si la query a changé pendant l’attente, on ignore
    if (state.query != query) return;

    // 5) Résolution de l’Either
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

  String _failureMessage(Failure f) {
    // Adapte si tu as des sous-classes (NetworkFailure, ServerFailure, etc.)
    // et/ou une propriété `message`. Par défaut :
    return f.toString();
  }

}