import 'package:volleyapp/features/club/domain/entities/club.dart';

abstract class ClubPickerState {
  const ClubPickerState();
}

class ClubPickerLoading extends ClubPickerState {}

class ClubPickerLoaded extends ClubPickerState {
  final List<Club> clubs;
  final String? selectedClubId;

  const ClubPickerLoaded({required this.clubs, this.selectedClubId});

  ClubPickerLoaded copyWith({
    List<Club>? clubs,
    String? selectedClubId,
  }) {
    return ClubPickerLoaded(
      clubs: clubs ?? this.clubs,
      selectedClubId: selectedClubId ?? this.selectedClubId,
    );
  }
}

class ClubPickerError extends ClubPickerState {
  final String message;
  const ClubPickerError(this.message);
}
