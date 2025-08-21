import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:volleyapp/app/routing/app_route.dart';
import 'package:volleyapp/app/routing/go_router_refresh_stream.dart';


import 'package:volleyapp/features/auth/presentation/pages/home_page.dart';
import 'package:volleyapp/features/club/presentation/pages/JoinClubPage.dart';
import 'package:volleyapp/features/club/presentation/pages/create_or_join_club_page.dart';
import 'package:volleyapp/features/session/domain/session_state_provider.dart';
import 'package:volleyapp/features/session/domain/session_status.dart';

import 'package:volleyapp/features/auth/presentation/pages/splash_page.dart';
import 'package:volleyapp/features/auth/presentation/pages/sign_in_page.dart';
import 'package:volleyapp/features/auth/presentation/pages/sign_up_page.dart';
import 'package:volleyapp/features/user/presentation/pages/add_user_page.dart';

GoRouter createRouter(SessionStateProvider session) {
  // Deep-link protégé mémorisé
  String? pending;

  bool isPublic(String path) => {
    AppRoute.splash.path,
    AppRoute.signIn.path,
    AppRoute.signUp.path,
    AppRoute.error.path,
  }.contains(path);

  bool isProtected(String path) => !isPublic(path);

  // Splash : délai minimal (appliqué une seule fois)
  const splashMin = Duration(milliseconds: 1500);
  bool splashDelayDone = false;

  bool isAt(GoRouterState state, AppRoute route) =>
      state.matchedLocation == route.path;

  return GoRouter(
    initialLocation: AppRoute.splash.path,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: GoRouterRefreshStream(session.status),

    routes: [
      GoRoute(
        name: AppRoute.splash.name,
        path: AppRoute.splash.path,
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        name: AppRoute.signIn.name,
        path: AppRoute.signIn.path,
        builder: (_, __) => const SignInPage(),
      ),
      GoRoute(
        name: AppRoute.signUp.name,
        path: AppRoute.signUp.path,
        builder: (_, __) => const SignUpPage(),
      ),
      GoRoute(
        name: AppRoute.completeProfile.name,
        path: AppRoute.completeProfile.path,
        builder: (_, __) => const AddUserPage(),
      ),
      GoRoute(
        name: AppRoute.home.name,
        path: AppRoute.home.path,
        builder: (_, __) => const JoinClubPage(),
      ),
    ],

    redirect: (context, state) async {
      final s = session.current;
      final loc = state.matchedLocation;
      final fullUri = state.uri.toString();

      switch (s) {
        case SessionStatus.unknown:
          if (!isAt(state, AppRoute.splash)) pending ??= fullUri;
          return AppRoute.splash.path;

        case SessionStatus.unauthenticated:
          if (isAt(state, AppRoute.splash)) {
            if (!splashDelayDone) {
              splashDelayDone = true;
              await Future.delayed(splashMin);
            }
            return AppRoute.signIn.path;
          }
          if (isProtected(loc)) {
            pending ??= fullUri;
            return AppRoute.signIn.path;
          }
          return null;

        case SessionStatus.profileIncomplete:
          if (!isAt(state, AppRoute.completeProfile)) {
            if (isAt(state, AppRoute.splash) && !splashDelayDone) {
              splashDelayDone = true;
              await Future.delayed(splashMin);
            }
            return AppRoute.completeProfile.path;
          }
          return null;

        case SessionStatus.authenticated:
          if (isAt(state, AppRoute.splash) ||
              isAt(state, AppRoute.signIn) ||
              isAt(state, AppRoute.signUp) ||
              isAt(state, AppRoute.completeProfile)) {
            final target = pending ?? AppRoute.home.path;
            pending = null;
            if (isAt(state, AppRoute.splash) && !splashDelayDone) {
              splashDelayDone = true;
              await Future.delayed(splashMin);
            }
            return target;
          }
          return null;
      }
    },
  );
}
