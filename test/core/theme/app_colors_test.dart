import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Color Token Leak Test', () {
    test('No hardcoded hex values outside app_colors.dart', () async {
      final libDir = Directory('lib');
      final dartFiles = libDir
          .listSync(recursive: true)
          .where((entity) =>
              entity is File &&
              entity.path.endsWith('.dart') &&
              !entity.path.contains('app_colors.dart') &&
              !entity.path.contains('.freezed.dart') &&
              !entity.path.contains('.g.dart'));

      final hexPattern = RegExp(r'Color\(0x[0-9A-Fa-f]{8}\)');
      final violations = <String>[];

      for (final file in dartFiles) {
        final content = await (file as File).readAsString();
        if (hexPattern.hasMatch(content)) {
          violations.add(file.path);
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'The following files contain hardcoded Color hex values. All colors must be defined in app_colors.dart:\n${violations.join('\n')}',
      );
    });
  });
}
