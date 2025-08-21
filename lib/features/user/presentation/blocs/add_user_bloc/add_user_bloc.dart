import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/user/domain/use_cases/add_user/add_user_params.dart';
import 'package:volleyapp/features/user/domain/use_cases/add_user/add_user_usecase.dart';
import 'package:volleyapp/features/user/presentation/blocs/add_user_bloc/add_user_event.dart';
import 'package:volleyapp/features/user/presentation/blocs/add_user_bloc/add_user_state.dart';
import 'package:volleyapp/features/user/domain/entities/user.dart' as domain;

class AddUserBloc extends Bloc<AddUserEvent, AddUserState> {
  final FirebaseAuth _auth;
  final AddUserUseCase _addUserUseCase;

  AddUserBloc({
    required FirebaseAuth auth,
    required AddUserUseCase addUserUseCase,
  })  : _auth = auth,
        _addUserUseCase = addUserUseCase,
        super(AddUserState.initial()) {
    on<FirstnameChanged>(_onFirstnameChanged);
    on<LastnameChanged>(_onLastnameChanged);
    on<BirthdateChanged>(_onBirthdateChanged);
    on<AvatarChanged>(_onAvatarChanged);
    on<SubmitAddUser>(_onSubmit);
  }

  void _onFirstnameChanged(
      FirstnameChanged event, Emitter<AddUserState> emit) {
    final value = event.firstname.trim();
    emit(state.copyWith(
      firstName: value,
      firstNameError: value.isEmpty ? 'Le prénom ne peut pas être vide' : null,
    ));
  }

  void _onLastnameChanged(
      LastnameChanged event, Emitter<AddUserState> emit) {
    final value = event.lastname.trim();
    emit(state.copyWith(
      lastName: value,
      lastNameError: value.isEmpty ? 'Le nom ne peut pas être vide' : null,
    ));
  }

  void _onBirthdateChanged(
      BirthdateChanged event, Emitter<AddUserState> emit) {
    //TODO ? ajouter age minimum ?
    emit(state.copyWith(
      birthdate: event.birthdate,
      birthdateError: null,
    ));
  }

  void _onAvatarChanged(
      AvatarChanged event, Emitter<AddUserState> emit) {
    emit(state.copyWith(
      avatarUrl: event.avatarUrl,
      avatarUrlError: null,
    ));
  }

  Future<void> _onSubmit(
      SubmitAddUser event, Emitter<AddUserState> emit) async {

    String? firstErr =
    state.firstName.trim().isEmpty ? 'Le prénom ne peut pas être vide' : null;
    String? lastErr =
    state.lastName.trim().isEmpty ? 'Le nom ne peut pas être vide' : null;
    String? birthErr =
    state.birthdate == null ? 'La date de naissance est obligatoire' : null;

    if (firstErr != null || lastErr != null || birthErr != null) {
      emit(state.copyWith(
        firstNameError: firstErr,
        lastNameError: lastErr,
        birthdateError: birthErr,
      ));
      return;
    }

    final user = _auth.currentUser;
    if (user == null) return;

    emit(state.copyWith(isSubmitting: true));

    try {


     final Either<Failure,domain.User> result = await _addUserUseCase(AddUserParams(
          id: user.uid,
          firstname: state.firstName.trim(),
          lastname: state.lastName.trim(),
          email: user.email!, // TODO jcp si ! vrm meilleur pratique après normalement impossible on vient de créer compte
          birthdate: state.birthdate!,
      ));

     result.fold(
           (failure) => emit(state.copyWith(
         isSubmitting: false,
         isSuccess: false,
         submitError: failure.message,
       )),
           (user) => emit(state.copyWith(
         isSubmitting: false,
         isSuccess: true,
       )),
     );

    } catch (err) {
      // Tu n’as pas de submitError dans le state → on se contente de reset isSubmitting
      // (Si tu veux afficher un SnackBar global, ajoute un champ submitError dans AddUserState)
      emit(state.copyWith(isSubmitting: false, isSuccess: false));
    }
  }
}
