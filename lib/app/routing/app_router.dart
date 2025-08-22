import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:volleyapp/app/routing/app_route.dart';
import 'package:volleyapp/app/routing/go_router_refresh_stream.dart';
import 'package:volleyapp/features/auth/presentation/pages/home_page.dart';
import 'package:volleyapp/features/club/presentation/pages/club_page.dart';
import 'package:volleyapp/features/club/presentation/pages/create_or_join_club_page.dart';
import 'package:volleyapp/features/club/presentation/pages/create_team_page.dart';
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
      // Page "home" pour créer/rejoindre un club (quand pas de club)
      GoRoute(
        name: AppRoute.home.name,
        path: AppRoute.home.path,
        builder: (_, __) => const HomePage(),
      ),
      // ✅ Page quand l’utilisateur a déjà un club
      GoRoute(
        name: AppRoute.addJoinClub.name,
        path: AppRoute.addJoinClub.path,
        builder: (_, __) => const CreateOrJoinClubPage(),
      ),
      GoRoute(
        name: AppRoute.team.name,
        path: AppRoute.team.path,
        builder: (_, __) => const CreateTeamPage(),
      ),
      GoRoute(
        name: AppRoute.club.name,
        path: AppRoute.club.path,
        builder: (_, __) => const ClubPage(),
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
            return AppRoute.signIn.path;
          }
          if (isProtected(loc)) {
            pending ??= fullUri;
            return AppRoute.signIn.path;
          }
          return null;

        case SessionStatus.profileIncomplete:
          if (!isAt(state, AppRoute.completeProfile)) {
            if (isAt(state, AppRoute.splash)) {
              // no-op
            }
            return AppRoute.completeProfile.path;
          }
          return null;

        case SessionStatus.noClub:
        // profil OK mais pas de club -> dirige vers CreateOrJoinClubPage (home)
          if (isAt(state, AppRoute.splash) ||
              isAt(state, AppRoute.signIn) ||
              isAt(state, AppRoute.signUp) ||
              isAt(state, AppRoute.completeProfile) ||
              isAt(state, AppRoute.addJoinClub)) { // si on se retrouve au club, on renvoie home
            final target = pending ?? AppRoute.addJoinClub.path;
            pending = null;
            return target;
          }
          // Si l’URL demandée est protégée mais autre chose que home, on garde pending → home
          if (isProtected(loc) && !isAt(state, AppRoute.home)) {
            pending ??= fullUri;
            return AppRoute.home.path;
          }
          return null;

        case SessionStatus.inClub:
        // connecté + profil OK + a un club -> bascule vers ClubPage
          if (isAt(state, AppRoute.splash) ||
              isAt(state, AppRoute.signIn) ||
              isAt(state, AppRoute.signUp) ||
              isAt(state, AppRoute.completeProfile) ||
              isAt(state, AppRoute.home)) { // s'il traine sur la home, on envoie au club
            final target = pending ?? AppRoute.home.path;
            pending = null;
            return target;
          }
          return null;
      }
    },
  );
}
