import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:volleyapp/app/config/app_config.dart';
import 'package:volleyapp/app/routing/app_router.dart';
import 'package:volleyapp/app/theme/app_theme.dart';
import 'package:volleyapp/features/session/domain/session_state_provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final session = GetIt.I<SessionStateProvider>();
    _router = createRouter(session);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConfig.appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
