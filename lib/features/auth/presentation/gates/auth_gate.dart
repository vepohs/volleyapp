import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:volleyapp/app/router/app_router.dart';
import 'package:volleyapp/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:volleyapp/features/auth/presentation/blocs/auth_bloc/auth_state.dart';


class AuthGate extends StatelessWidget {
  final Widget child;
  const AuthGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
        } else if (state is Unauthenticated) {
          context.go(AppRoutes.login);
        }
      },
      child: child,
    );
  }
}
