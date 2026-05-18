import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/shared/widgets/bento_card.dart';

void main() {
  testWidgets('GlassCard pumps and displays child', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: GlassCard(
              onTap: () {
                tapped = true;
              },
              child: const Text('Test GlassCard Content'),
            ),
          ),
        ),
      ),
    );

    // Verify child text is displayed
    expect(find.text('Test GlassCard Content'), findsOneWidget);

    // Tap the GlassCard and verify callback
    await tester.tap(find.text('Test GlassCard Content'));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });
}
