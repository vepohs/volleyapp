import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/auth/domain/entitites/auth_user.dart';
import 'package:volleyapp/features/auth/domain/use_cases/sign_up_with_email/sign_up_with_email_params.dart';
import 'package:volleyapp/features/auth/domain/use_cases/sign_up_with_email/sign_up_with_email_usecase.dart';
import 'package:volleyapp/features/auth/presentation/blocs/sign_up_form_bloc/sign_up_form_event.dart';
import 'package:volleyapp/features/auth/presentation/blocs/sign_up_form_bloc/sign_up_form_state.dart';

class SignUpFormBloc extends Bloc<SignUpFormEvent, SignUpFormState>{

  final SignUpWithEmailUseCase _signUpWithEmail;

  SignUpFormBloc({required SignUpWithEmailUseCase signUpWithEmail})
    : _signUpWithEmail = signUpWithEmail, super(SignUpFormState.initial())
  {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<SignUpSubmitted>(_onDefaultSignUpSubmitted);
  }

  void _onEmailChanged(EmailChanged event, Emitter<SignUpFormState> emit){
    final email = event.email.trim();

    emit(state.copyWith(
      email: email,
      emailError: email.isEmpty ? "Peut pas vide" : null
    ));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<SignUpFormState> emit) {
    final password = event.password.trim();

    emit(state.copyWith(
      password: password,
      passwordError: password.isEmpty ? "Peut pas etre vide" : null
    ));
  }

  Future<void> _onDefaultSignUpSubmitted(
      SignUpSubmitted event, Emitter<SignUpFormState> emit) async {

    if (state.emailError != null || state.passwordError != null) return;

    emit(state.copyWith(isSubmitting: true, submitError: null));

    final Either<Failure, AuthUser> result = await _signUpWithEmail(
      SignUpWithEmailParams(email: state.email, password: state.password),
    );

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