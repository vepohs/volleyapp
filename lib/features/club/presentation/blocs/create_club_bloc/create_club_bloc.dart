import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/club/domain/use_cases/add_club/add_club_params.dart';
import 'package:volleyapp/features/club/domain/use_cases/add_club/add_club_use_case.dart';
import 'package:volleyapp/features/club_membership/domain/entities/role.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/add_club_membership_use_case/add_club_membership_use_case.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/add_club_membership_use_case/add_club_memership_params.dart';
import '../../../domain/entities/club.dart';
import 'create_club_event.dart';
import 'create_club_state.dart';

class CreateClubBloc extends Bloc<CreateClubEvent, CreateClubState> {
  final FirebaseAuth _auth;
  final AddClubUseCase _addClubUseCase;
  final AddClubMembershipUseCase _addClubMembershipUseCase;

  CreateClubBloc({
    required AddClubUseCase addClubUseCase, required addClubMembershipUseCase, required FirebaseAuth auth})
      : _auth = auth,
        _addClubUseCase = addClubUseCase,
        _addClubMembershipUseCase = addClubMembershipUseCase,
        super(CreateClubState.initial()) {
    on<ClubNameChanged>(_onClubNameChanged);
    on<SubmitCreateClub>(_onSubmitCreateClub);
  }

  void _onClubNameChanged(ClubNameChanged event,
      Emitter<CreateClubState> emit) {
    final value = event.clubName.trim();
    emit(state.copyWith(
      clubName: value,
      clubNameError: value.isEmpty ? 'Le nom du club est requis' : null,
    ));
  }

  Future<void> _onSubmitCreateClub(SubmitCreateClub event,
      Emitter<CreateClubState> emit) async {
    if (state.clubName
        .trim()
        .isEmpty) {
      emit(state.copyWith(clubNameError: 'Le nom du club est requis'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, submitError: null));

    try {

      final user = _auth.currentUser;
      if (user == null)return;

      final Either<Failure, Club> createClubResult = await _addClubUseCase(
          AddClubParams(name: state.clubName)
      );
      createClubResult.fold(
              (failure) =>
              emit(state.copyWith(
                isSubmitting: false,
                isSuccess: false,
                submitError: failure.message,
              )),
              (club) =>
              _addClubMembershipUseCase(
                  AddClubMembershipParams(
                  clubId: club.id,
                  userId: user.uid,
                  role: Role.presidenggggg))
      );
    emit(state.copyWith(isSubmitting: false, isSuccess: true));

    } catch (e) {
    emit(state.copyWith(
    isSubmitting: false,
    isSuccess: false,
    submitError: e.toString(),
    ));
    }
  }
}
