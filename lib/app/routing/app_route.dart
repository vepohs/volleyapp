enum AppRoute {
  splash,
  signIn,
  signUp,
  completeProfile,
  event,
  error,
  addJoinClub,
  team,
  club,
}

extension AppRouteX on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.splash:
        return '/splash';
      case AppRoute.signIn:
        return '/sign_in';
      case AppRoute.signUp:
        return '/sign_up';
      case AppRoute.completeProfile:
        return '/complete_profile';
      case AppRoute.event:
        return '/event';
      case AppRoute.error:
        return '/error';
      case AppRoute.addJoinClub:
        return '/addJoinClub';
      case AppRoute.team:
        return '/team';
      case AppRoute.club:
        return '/club';
    }
  }
}
