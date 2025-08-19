import 'package:go_router/go_router.dart';
import 'package:volleyapp/features/auth/presentation/pages/splash_page.dart';


class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
}

final router = GoRouter(
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashPage()),
  ],
);

