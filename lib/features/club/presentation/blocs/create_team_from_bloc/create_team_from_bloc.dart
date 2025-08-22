import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/features/club/presentation/blocs/create_team_from_bloc/create_team_from_event.dart';
import 'package:volleyapp/features/club/presentation/blocs/create_team_from_bloc/create_team_from_state.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/get_club_by%20_user_id/get_club_user_id_use_case.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/get_club_by%20_user_id/get_club_by_user_id_params.dart';
import 'package:volleyapp/features/team/domain/use_cases/add_team/add_team_use_case.dart';
import 'package:volleyapp/features/team/domain/use_cases/add_team/add_team_params.dart';
import 'package:volleyapp/features/club_team/domain/use_cases/add_club_team/add_club_team_use_case.dart';
import 'package:volleyapp/features/club_team/domain/use_cases/add_club_team/add_club_team_params.dart';

class CreateTeamFormBloc extends Bloc<CreateTeamFormEvent, CreateTeamFormState> {

  final GetClubUserIdUseCase getClubUserIdUseCase;
  final AddTeamUseCase addTeamUseCase;
 final AddClubTeamUseCase addClubTeamUseCase;
  final FirebaseAuth auth;

  CreateTeamFormBloc({
    required this.getClubUserIdUseCase,
   required this.addTeamUseCase,
   required this.addClubTeamUseCase,
    required this.auth,
  }) : super(const CreateTeamFormState()) {

    on<TeamNameChanged>(_onNameChanged);
    on<TeamCategoryChanged>(_onCategoryChanged);
    on<TeamGenderChanged>(_onGenderChanged);
    on<TeamLevelChanged>(_onLevelChanged);
    on<TeamAvatarChanged>(_onAvatarChanged);
    on<SubmitTeamForm>(_onSubmit);
  }

  void _onNameChanged(TeamNameChanged e, Emitter<CreateTeamFormState> emit) {
    final err = e.name.trim().isEmpty ? 'Le nom est requis' : null;
    emit(state.copyWith(name: e.name, nameError: err));
  }

  void _onCategoryChanged(TeamCategoryChanged e, Emitter<CreateTeamFormState> emit) {
    final err = e.category.trim().isEmpty ? 'La catégorie est requise' : null;
    emit(state.copyWith(category: e.category, categoryError: err));
  }

  void _onGenderChanged(TeamGenderChanged e, Emitter<CreateTeamFormState> emit) {
    final err = e.gender.trim().isEmpty ? 'Le genre est requis' : null;
    emit(state.copyWith(gender: e.gender, genderError: err));
  }

  void _onLevelChanged(TeamLevelChanged e, Emitter<CreateTeamFormState> emit) {
    final err = e.level.trim().isEmpty ? 'Le niveau est requis' : null;
    emit(state.copyWith(level: e.level, levelError: err));
  }

  void _onAvatarChanged(TeamAvatarChanged e, Emitter<CreateTeamFormState> emit) {
    // avatar optionnel
    emit(state.copyWith(avatarUrl: e.avatarUrl));
  }

  Future<void> _onSubmit(SubmitTeamForm event, Emitter<CreateTeamFormState> emit) async {

    final nameErr      = state.name.trim().isEmpty      ? 'Le nom est requis' : null;
    final categoryErr  = state.category.trim().isEmpty  ? 'La catégorie est requise' : null;
    final genderErr    = state.gender.trim().isEmpty    ? 'Le genre est requis' : null;
    final levelErr     = state.level.trim().isEmpty     ? 'Le niveau est requis' : null;

    if (nameErr != null || categoryErr != null || genderErr != null || levelErr != null) {
      emit(state.copyWith(
        nameError: nameErr,
        categoryError: categoryErr,
        genderError: genderErr,
        levelError: levelErr,
      ));
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null, isSuccess: false));

    final user = auth.currentUser;
    if (user == null) {
      emit(state.copyWith(isSubmitting: false, errorMessage: 'Utilisateur non connecté.'));
      return;
    }

    final clubEither = await getClubUserIdUseCase(GetClubByUserIdParams(userId: user.uid));
    if (clubEither.isLeft()) {
      final failure = clubEither.swap().getOrElse(() => throw StateError('Failure manquante'));
      emit(state.copyWith(isSubmitting: false, errorMessage: failure.message));
      return;
    }

    final clubOption = clubEither.getOrElse(() => const None());
    if (clubOption.isNone()) {
      emit(state.copyWith(isSubmitting: false, errorMessage: 'Aucun club trouvé.'));
      return;
    }

    final clubMembership = clubOption.getOrElse(() => throw StateError('ClubMembership manquant'));
    final clubId = clubMembership.clubId;

    final teamEither = await addTeamUseCase(AddTeamParams(
      name: state.name,
      category: state.category,
      gender: state.gender,
      level: state.level,
      avatarUrl: state.avatarUrl,
    ));

    if (teamEither.isLeft()) {
      final failure = teamEither.swap().getOrElse(() => throw StateError('Failure manquante'));
      emit(state.copyWith(isSubmitting: false, errorMessage: failure.message));
      return;
    }

    final team = teamEither.getOrElse(() => throw StateError('Team manquante'));

    final linkEither = await addClubTeamUseCase(AddClubTeamParams(
      clubId: clubId,
      teamId: team.id,
    ));

    linkEither.fold(
          (failure) => emit(state.copyWith(isSubmitting: false, errorMessage: failure.message)),
          (_)        => emit(state.copyWith(isSubmitting: false, isSuccess: true)),
    );
  }
}
