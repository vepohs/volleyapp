import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/club/domain/use_cases/get_filtered_club_by_name/get_filtered_club_by_name_params.dart';
import 'package:volleyapp/features/club/domain/use_cases/get_filtered_club_by_name/get_filtered_club_by_name_use_case.dart';
import 'join_club_request_event.dart';
import 'join_club_request_state.dart';
import 'package:stream_transform/stream_transform.dart';


EventTransformer<T> debounce<T>(Duration d) =>
        (events, mapper) => events.debounce(d).switchMap(mapper);

class ClubSearchBloc extends Bloc<ClubEvent, ClubSearchState> {
  final GetFilteredClubByNameUseCase _getFilteredClubByNameUseCase;

  ClubSearchBloc(GetFilteredClubByNameUseCase getFilteredClubByNameUseCase) :
        _getFilteredClubByNameUseCase = getFilteredClubByNameUseCase,
        super(const ClubSearchState()) {
    on<SearchClubsChanged>(_onSearch, transformer: debounce(const Duration(milliseconds: 300)));
    on<ClubSelected>((e, emit) => emit(state.copyWith(selected: e.club)));
  }

  Future<void> _onSearch(
      SearchClubsChanged e,
      Emitter<ClubSearchState> emit,
      ) async {
    final q = e.query.trim();

    // 1) Court-circuit pour requêtes trop courtes
    // if (q.length < 2) {
    //   emit(state.copyWith(
    //     query: q,
    //     status: ClubSearchStatus.empty,
    //     results: const [],
    //     error: null,
    //     selected: null,
    //   ));
    //   return;
    // }

    // 2) Loading pour la query courante
    emit(state.copyWith(
      query: q,
      status: ClubSearchStatus.loading,
      error: null,
      selected: null,
    ));

    final currentQuery = q;
    print("currentQuery");
    print(currentQuery);
    // 3) Appel du use case (Either<Failure, List<Club>>)

    final either = await _getFilteredClubByNameUseCase(
      GetFilteredClubByNameParams(query: currentQuery),
    );

    // 4) Anti-race : si la query a changé pendant l’attente, on ignore
    if (state.query != currentQuery) return;

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
          print("NORMALEMENT CEST VIDE");
          print(results.length);
          emit(state.copyWith(
            status: ClubSearchStatus.empty,
            results: const [],
            error: null,
          ));
        } else {
          print("pas la taille qui compte");
          print(results.length);
          for(int i =0;i<results.length; i++){
            print(results[i].name);
          }
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