import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:volleyapp/features/session/domain/session_state_provider.dart';
import 'package:volleyapp/features/auth/presentation/pages/sign_in_page.dart';
import 'package:volleyapp/features/auth/presentation/pages/sign_up_page.dart';
import 'package:volleyapp/features/auth/presentation/pages/splash_page.dart';
import 'package:volleyapp/features/user/presentation/pages/add_user_page.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _sub;
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
    // Tick initial pour forcer une évaluation au boot
    scheduleMicrotask(notifyListeners);
  }
  @override
  void dispose() { _sub.cancel(); super.dispose(); }
}

GoRouter createRouter(SessionStateProvider session) {
  // Deep-link protégé mémorisé
  String? pending;

  bool isPublic(String path) =>
      path == '/splash' || path == '/login' || path == '/sign_up' || path == '/error';

  bool isProtected(String path) => !isPublic(path);

  // Durée minimale d’affichage du Splash
  const splashMinDuration = Duration(milliseconds: 3000);
  bool splashDelayDone = false; // on ne retarde qu’une fois

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(session.status),

    routes: [
      GoRoute(path: '/splash',  builder: (_, __) => const SplashPage()),
      GoRoute(path: '/login',   builder: (_, __) => const SignInPage()),
      GoRoute(path: '/sign_up', builder: (_, __) => const SignUpPage()),
      GoRoute(path: '/home',    builder: (_, __) => const AddUserPage()), // TODO pas bon c'est pour test
      // … tes autres routes protégées/public
    ],

    // redirect async pour pouvoir "await" le délai Splash
    redirect: (context, state) async {
      final s       = session.current;
      final loc     = state.matchedLocation;
      final fullUri = state.uri.toString();

      switch (s) {
        case SessionStatus.unknown:
        // On reste strictement sur /splash; on mémorise la cible si nécessaire
          if (loc != '/splash') {
            pending ??= fullUri;
            return '/splash';
          }
          return null;

        case SessionStatus.unauthenticated:
        // Quitter /splash -> /login après délai (une seule fois)
          if (loc == '/splash') {
            if (!splashDelayDone) {
              splashDelayDone = true;
              await Future.delayed(splashMinDuration);
            }
            return '/login';
          }
          // Public OK, privé -> login + pending
          if (isProtected(loc)) {
            pending ??= fullUri;
            return '/login';
          }
          return null;

        case SessionStatus.authenticated:
        // Depuis /splash|/login|/sign_up -> pending ou /home (avec délai si on est sur /splash)
          if (loc == '/splash' || loc == '/login' || loc == '/sign_up') {
            final target = pending ?? '/home';
            pending = null;
            if (loc == '/splash' && !splashDelayDone) {
              splashDelayDone = true;
              await Future.delayed(splashMinDuration);
            }
            return target;
          }
          return null;
      }
    },
  );
}
