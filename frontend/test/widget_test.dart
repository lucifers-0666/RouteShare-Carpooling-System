import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sahyan/app/app.dart';

void main() {
  testWidgets('SahyanApp initializes successfully smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SahyanApp(),
      ),
    );

    // Verify Sahyān brand text renders on Splash Screen
    expect(find.text('Sahyān'), findsOneWidget);

    // Allow splash timer to complete
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
