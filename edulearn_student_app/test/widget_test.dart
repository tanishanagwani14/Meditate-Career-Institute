import 'package:flutter_test/flutter_test.dart';

import 'package:edulearn_student_app/main.dart';
import 'package:edulearn_student_app/router/app_router.dart';

void main() {
  testWidgets('App boots', (WidgetTester tester) async {
    await tester.pumpWidget(EduLearnApp(router: createAppRouter()));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('EduLearn'), findsOneWidget);
    // Splash schedules a 2.5s navigation timer; advance time so the test harness does not report pending timers.
    await tester.pump(const Duration(seconds: 3));
  });
}
