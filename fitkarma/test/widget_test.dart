// Basic Flutter widget test placeholder

import 'package:flutter_test/flutter_test.dart';

import 'package:fitkarma/main.dart';

void main() {
  testWidgets('FitKarma app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FitKarmaApp());

    // Verify that the placeholder text is shown
    expect(find.text('FitKarma - Placeholder'), findsOneWidget);
  });
}
