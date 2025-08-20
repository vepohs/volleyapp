import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/auth/domain/entitites/auth_user.dart';
import 'package:volleyapp/features/auth/domain/use_cases/sign_in_with_email/sign_in_with_email_params.dart';
import 'package:volleyapp/features/auth/domain/use_cases/sign_in_with_email/sign_in_with_email_use_case.dart';
import 'package:volleyapp/features/auth/domain/use_cases/sign_in_with_google/sign_in_with_google.dart';
import 'package:volleyapp/features/auth/presentation/blocs/sign_in_form_bloc/sign_in_form_event.dart';
import 'package:volleyapp/features/auth/presentation/blocs/sign_in_form_bloc/sign_in_form_state.dart';

class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState>{

  final SignInWithEmailUseCase _signInWithEmailUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;

  SignInFormBloc(
      {required SignInWithEmailUseCase signInWithEmailUseCase, required signInWithGoogleUseCase}) :
        _signInWithEmailUseCase = signInWithEmailUseCase,
        _signInWithGoogleUseCase = signInWithGoogleUseCase,
        super(SignInFormState.initial())
  {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<DefaultSignInSubmitted>(_onDefaultSignInSubmitted);
    on<GoogleSignInSubmitted>(_onGoogleSignInSubmitted);
  }

  void _onEmailChanged(EmailChanged event, Emitter<SignInFormState> emit){
    final email = event.email.trim();

    emit(state.copyWith(
        email: email,
        emailError: email.isEmpty ? "Peut pas vide" : null
    ));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<SignInFormState> emit) {
    final password = event.password.trim();

    emit(state.copyWith(
        password: password,
        passwordError: password.isEmpty ? "Peut pas etre vide" : null
    ));
  }

  Future<void> _onDefaultSignInSubmitted (DefaultSignInSubmitted event, Emitter<SignInFormState> emit) async {

    if (state.emailError != null || state.passwordError != null) return;

    emit(state.copyWith(isSubmitting: true, submitError: null));

    final Either<Failure,AuthUser> result = await _signInWithEmailUseCase(SignInWithEmailParams(email: state.email, password: state.password));

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
  }

  Future<void> _onGoogleSignInSubmitted (GoogleSignInSubmitted event, Emitter<SignInFormState>emit) async {

    emit(state.copyWith(isSubmitting: true, submitError: null));

    final Either<Failure,AuthUser> result = await _signInWithGoogleUseCase();

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
  }

}