enum AppRoute {
  splash,
  signIn,
  signUp,
  completeProfile,
  home,
  error,
}

extension AppRouteX on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.splash:           return '/splash';
      case AppRoute.signIn:           return '/sign_in';
      case AppRoute.signUp:           return '/sign_up';
      case AppRoute.completeProfile:  return '/complete_profile';
      case AppRoute.home:             return '/home';
      case AppRoute.error:            return '/error';
    }
  }
}
