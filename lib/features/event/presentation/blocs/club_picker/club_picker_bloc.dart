import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/features/club/domain/use_cases/get_all_club/get_all_club_use_case.dart';
import 'club_picker_event.dart';
import 'club_picker_state.dart';

class ClubPickerBloc extends Bloc<ClubPickerEvent, ClubPickerState> {
  final GetAllClubUseCase getAllClub;

  ClubPickerBloc({required this.getAllClub}) : super(ClubPickerLoading()) {
    on<ClubPickerStarted>(_onStarted);
    on<ClubSelected>(_onClubSelected);
  }

  Future<void> _onStarted(
      ClubPickerStarted event, Emitter<ClubPickerState> emit) async {
    emit(ClubPickerLoading());
    final result = await getAllClub();
    result.fold(
          (failure) => emit(ClubPickerError(failure.message)),
          (clubs) => emit(ClubPickerLoaded(clubs: clubs)),
    );
  }

  void _onClubSelected(ClubSelected event, Emitter<ClubPickerState> emit) {
    final currentState = state;
    if (currentState is ClubPickerLoaded) {
      emit(currentState.copyWith(selectedClubId: event.clubId));
    }
  }
}
