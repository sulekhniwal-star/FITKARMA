import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/health/glucose_providers.dart';

void main() {
  group('GlucoseClassification', () {
    group('hypoglycemic threshold', () {
      test('value < 70 returns hypoglycemic for any timing', () {
        expect(GlucoseClassification.classify(69, 'fasting'), GlucoseClassification.hypoglycemic);
        expect(GlucoseClassification.classify(50, 'post-meal'), GlucoseClassification.hypoglycemic);
        expect(GlucoseClassification.classify(30, 'random'), GlucoseClassification.hypoglycemic);
        expect(GlucoseClassification.classify(0, 'bedtime'), GlucoseClassification.hypoglycemic);
      });

      test('value exactly 69 is hypoglycemic', () {
        expect(GlucoseClassification.classify(69.9, 'fasting'), GlucoseClassification.hypoglycemic);
      });

      test('value exactly 70 transitions to normal', () {
        expect(GlucoseClassification.classify(70, 'fasting'), GlucoseClassification.normal);
      });
    });

    group('fasting thresholds', () {
      test('value 99 is normal (upper bound)', () {
        expect(GlucoseClassification.classify(99, 'fasting'), GlucoseClassification.normal);
      });

      test('value 100 is pre-diabetic (lower bound)', () {
        expect(GlucoseClassification.classify(100, 'fasting'), GlucoseClassification.preDiabetic);
      });

      test('value 125 is pre-diabetic (upper bound)', () {
        expect(GlucoseClassification.classify(125, 'fasting'), GlucoseClassification.preDiabetic);
      });

      test('value 126 is diabetic (lower bound)', () {
        expect(GlucoseClassification.classify(126, 'fasting'), GlucoseClassification.diabetic);
      });
    });

    group('post-meal thresholds', () {
      test('value 139 is normal (upper bound)', () {
        expect(GlucoseClassification.classify(139, 'post-meal'), GlucoseClassification.normal);
      });

      test('value 140 is pre-diabetic (lower bound)', () {
        expect(GlucoseClassification.classify(140, 'post-meal'), GlucoseClassification.preDiabetic);
      });

      test('value 199 is pre-diabetic (upper bound)', () {
        expect(GlucoseClassification.classify(199, 'post-meal'), GlucoseClassification.preDiabetic);
      });

      test('value 200 is diabetic (lower bound)', () {
        expect(GlucoseClassification.classify(200, 'post-meal'), GlucoseClassification.diabetic);
      });
    });

    group('random/bedtime thresholds', () {
      test('random timing uses same thresholds as post-meal', () {
        expect(GlucoseClassification.classify(139, 'random'), GlucoseClassification.normal);
        expect(GlucoseClassification.classify(140, 'random'), GlucoseClassification.preDiabetic);
        expect(GlucoseClassification.classify(199, 'random'), GlucoseClassification.preDiabetic);
        expect(GlucoseClassification.classify(200, 'random'), GlucoseClassification.diabetic);
      });

      test('bedtime timing uses same thresholds as post-meal', () {
        expect(GlucoseClassification.classify(139, 'bedtime'), GlucoseClassification.normal);
        expect(GlucoseClassification.classify(140, 'bedtime'), GlucoseClassification.preDiabetic);
        expect(GlucoseClassification.classify(199, 'bedtime'), GlucoseClassification.preDiabetic);
        expect(GlucoseClassification.classify(200, 'bedtime'), GlucoseClassification.diabetic);
      });
    });

    group('edge cases', () {
      test('timing is case-insensitive', () {
        expect(GlucoseClassification.classify(100, 'FASTING'), GlucoseClassification.preDiabetic);
        expect(GlucoseClassification.classify(100, 'Fasting'), GlucoseClassification.preDiabetic);
        expect(GlucoseClassification.classify(100, 'FASTING'), GlucoseClassification.preDiabetic);
      });

      test('high values are diabetic', () {
        expect(GlucoseClassification.classify(500, 'fasting'), GlucoseClassification.diabetic);
        expect(GlucoseClassification.classify(1000, 'post-meal'), GlucoseClassification.diabetic);
      });
    });
  });

  group('GlucoseClassification.isCrisis', () {
    test('value < 54 is crisis', () {
      expect(GlucoseClassification.isCrisis(53), isTrue);
      expect(GlucoseClassification.isCrisis(30), isTrue);
      expect(GlucoseClassification.isCrisis(0), isTrue);
    });

    test('value exactly 54 is not crisis', () {
      expect(GlucoseClassification.isCrisis(54), isFalse);
    });

    test('value > 250 is crisis', () {
      expect(GlucoseClassification.isCrisis(251), isTrue);
      expect(GlucoseClassification.isCrisis(500), isTrue);
    });

    test('value exactly 250 is not crisis', () {
      expect(GlucoseClassification.isCrisis(250), isFalse);
    });

    test('normal range is not crisis', () {
      expect(GlucoseClassification.isCrisis(70), isFalse);
      expect(GlucoseClassification.isCrisis(100), isFalse);
      expect(GlucoseClassification.isCrisis(150), isFalse);
    });
  });
}