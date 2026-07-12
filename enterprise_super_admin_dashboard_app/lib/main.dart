import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'theme/enterprise_theme.dart';

void main() {
  runApp(const EnterpriseSuperAdminApp());
}

class EnterpriseSuperAdminApp extends StatelessWidget {
  const EnterpriseSuperAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EduTech Super Admin',
      debugShowCheckedModeBanner: false,
      theme: EnterpriseTheme.light(),
      routerConfig: enterpriseRouter,
    );
  }
}
