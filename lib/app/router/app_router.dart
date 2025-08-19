import 'package:go_router/go_router.dart';
import 'package:volleyapp/features/auth/presentation/pages/splash_page.dart';


class AppRoutes {
  static const splash = '/';
  static const login = '/signIn';
  static const register = '/signUp';
  static const home = '/home';
}

final router = GoRouter(
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashPage()),
  ],
);

