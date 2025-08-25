import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/app/di/service_locator.dart';
import 'package:volleyapp/features/club/domain/use_cases/get_all_club/get_all_club_use_case.dart';
import 'package:volleyapp/features/event/presentation/blocs/club_picker/club_picker_bloc.dart';
import 'package:volleyapp/features/event/presentation/blocs/club_picker/club_picker_event.dart';
import 'package:volleyapp/features/event/presentation/blocs/club_picker/club_picker_state.dart';

class ClubPicker extends StatelessWidget {
  final String? initialValue;
  final void Function(String clubId)? onChanged;

  const ClubPicker({super.key, this.initialValue, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClubPickerBloc(getAllClub: locator<GetAllClubUseCase>())
        ..add(ClubPickerStarted()),
      child: BlocBuilder<ClubPickerBloc, ClubPickerState>(
        builder: (context, state) {
          if (state is ClubPickerLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ClubPickerError) {
            return Text(state.message, style: const TextStyle(color: Colors.red));
          }

          if (state is ClubPickerLoaded) {
            // 👇 appliquer initialValue seulement après chargement
            if (initialValue != null &&
                state.selectedClubId == null &&
                state.clubs.any((c) => c.id == initialValue)) {
              context.read<ClubPickerBloc>().add(ClubSelected(initialValue!));
            }

            return InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Club',
                border: OutlineInputBorder(),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: state.selectedClubId,
                  hint: const Text('Sélectionner un club'),
                  items: [
                    for (final c in state.clubs)
                      DropdownMenuItem(value: c.id, child: Text(c.name)),
                  ],
                  onChanged: (id) {
                    if (id != null) {
                      context.read<ClubPickerBloc>().add(ClubSelected(id));
                      onChanged?.call(id);
                    }
                  },
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
