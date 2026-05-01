import 'package:flutter_test/flutter_test.dart';
import 'package:arabpay_id/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ArabPayApp());

    // Verify that onboarding text is present.
    expect(find.textContaining('Global Arab'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
