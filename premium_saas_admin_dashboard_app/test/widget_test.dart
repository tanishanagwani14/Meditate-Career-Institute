// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:premium_saas_admin_dashboard_app/main.dart';
import 'package:premium_saas_admin_dashboard_app/router/app_router.dart';

void main() {
  testWidgets('App boots', (WidgetTester tester) async {
    await tester.pumpWidget(SaasAdminApp(router: createAppRouter()));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Dashboard Overview'), findsOneWidget);
  });
}
