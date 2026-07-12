import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SaasAdminApp(router: createAppRouter()));
}

class SaasAdminApp extends StatelessWidget {
  const SaasAdminApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appThemeController,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'Premium SaaS Admin Dashboard',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(Brightness.light),
          darkTheme: buildAppTheme(Brightness.dark),
          themeMode: appThemeController.mode,
          routerConfig: router,
        );
      },
    );
  }
}
