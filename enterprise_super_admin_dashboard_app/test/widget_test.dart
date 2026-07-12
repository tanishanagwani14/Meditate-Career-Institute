import 'package:flutter_test/flutter_test.dart';

import 'package:enterprise_super_admin_dashboard_app/main.dart';

void main() {
  testWidgets('Enterprise shell shows platform overview', (WidgetTester tester) async {
    await tester.pumpWidget(const EnterpriseSuperAdminApp());
    await tester.pumpAndSettle();

    expect(find.text('Platform Overview'), findsWidgets);
    expect(find.textContaining('EduTech'), findsWidgets);
  });
}
