import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:volleyapp/features/auth/presentation/pages/home_page.dart';
import 'package:volleyapp/features/auth/presentation/pages/sign_up_page.dart';

import 'package:volleyapp/features/session/domain/session_state_provider.dart';
import 'package:volleyapp/features/session/domain/session_status.dart';

import 'package:volleyapp/features/auth/presentation/pages/splash_page.dart';
import 'package:volleyapp/features/auth/presentation/pages/sign_in_page.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _sub;
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }
  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

GoRouter createRouter(SessionStateProvider session) {
  bool isPublic(String loc) =>
      loc == '/login' || loc == '/sign_up' || loc == '/error';

  return GoRouter(
    refreshListenable: GoRouterRefreshStream(session.status),
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashPage()),
      GoRoute(path: '/login',  builder: (_, __) => const SignInPage()),
      GoRoute(path: '/sign_up', builder: (_, __) => const SignUpPage()),
      GoRoute(path: '/home',   builder: (_, __) => const HomePage()),
    ],
    redirect: (_, state) {
      final status = session.current;
      final loc = state.matchedLocation;

      switch (status) {
        case SessionStatus.unknown:
        // reste/va sur splash pendant la résolution
          return loc == '/splash' ? null : '/splash';

        case SessionStatus.unauthenticated:
        // autorise toutes les pages publiques (dont /sign_up)
          return isPublic(loc) ? null : '/login';

        case SessionStatus.authenticated:
        // si déjà loggé, éviter /login /sign_up /splash -> aller à /home
          if (loc == '/login' || loc == '/sign_up' || loc == '/splash') {
            return '/home';
          }
          return null;
      }
    },
  );
}
