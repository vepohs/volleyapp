import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/features/event/domain/use_cases/add_event/add_event_use_case.dart';
import 'package:volleyapp/features/event/presentation/blocs/add_event_event.dart';
import 'package:volleyapp/features/event/presentation/blocs/add_event_state.dart';

class AddEventBloc extends Bloc<AddEventEvent, AddEventState> {
  final AddEventUseCase _addEvent;

  AddEventBloc(this._addEvent) : super(const AddEventIdle()) {
    on<AddEventSubmitted>(_onSubmit);
  }

  Future<void> _onSubmit(
      AddEventSubmitted e,
      Emitter<AddEventState> emit,
      ) async {
    emit(const AddEventSubmitting());
    final res = await _addEvent(e.params);
    res.fold(
          (failure) => emit(AddEventFailure(failure.message)),
          (event) => emit(AddEventSuccess(event)),
    );
    emit(const AddEventIdle());
  }
}
