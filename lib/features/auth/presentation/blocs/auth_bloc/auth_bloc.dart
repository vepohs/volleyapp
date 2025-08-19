import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/features/auth/domain/use_cases/get_current_auth_user/get_current_user_auth_use_case.dart';
import 'package:volleyapp/features/auth/domain/use_cases/is_user_connected/is_user_connected_use_case.dart';
import 'package:volleyapp/features/auth/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:volleyapp/features/auth/presentation/blocs/auth_bloc/auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IsUserConnectedUseCase _isUserConnectedUseCase;
  final GetCurrentUserAuthUseCase _getCurrentUserAuthUseCase;

  AuthBloc(
      this._isUserConnectedUseCase,
      this._getCurrentUserAuthUseCase,
      ) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    final result = await _isUserConnectedUseCase();

    await result.fold(
          (failure) async => emit(AuthError(failure.message)),
          (isConnected) async {
        if (!isConnected) {
          emit(Unauthenticated());
          return;
        }

        final userResult = await _getCurrentUserAuthUseCase();

        userResult.fold(
              (failure) => emit(AuthError(failure.message)),
              (optionUser) => optionUser.fold(
                () => emit(Unauthenticated()),
                (user) => emit(Authenticated(user)),
          ),
        );
      },
    );
  }

}
