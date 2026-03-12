
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('FitKarma basic smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: FitKarmaApp()));

    // Verify that the home screen shows.
    expect(find.textContaining('Namaste, User'), findsOneWidget);
  });
}
