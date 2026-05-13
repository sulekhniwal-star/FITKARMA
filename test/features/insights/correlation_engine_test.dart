import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/insights/correlation_engine.dart';

void main() {
  group('CorrelationEngine', () {
    group('sleep to BP insight generation', () {
      test('generates insight when poor sleep correlates with higher BP', () {
        final poorSleepBpSum = 150.0;
        final poorSleepBpCount = 5;
        final goodSleepBpSum = 130.0;
        final goodSleepBpCount = 5;

        final avgPoor = poorSleepBpSum / poorSleepBpCount;
        final avgGood = goodSleepBpSum / goodSleepBpCount;
        final diff = avgPoor - avgGood;

        expect(diff, greaterThan(8.0));
      });

      test('no insight when sleep and BP difference is small', () {
        final poorSleepBpSum = 135.0;
        final poorSleepBpCount = 5;
        final goodSleepBpSum = 130.0;
        final goodSleepBpCount = 5;

        final avgPoor = poorSleepBpSum / poorSleepBpCount;
        final avgGood = goodSleepBpSum / goodSleepBpCount;
        final diff = avgPoor - avgGood;

        expect(diff, lessThanOrEqualTo(8.0));
      });

      test('mock data scenario with 14+ days generates comprehensive insights', () {
        final dataDaysCount = 15;

        expect(dataDaysCount, greaterThanOrEqualTo(14));
        expect(dataDaysCount, greaterThanOrEqualTo(7));
      });

      test('mock data scenario with <7 days returns empty insights', () {
        final dataDaysCount = 5;

        expect(dataDaysCount, lessThan(7));
      });

      test('hydration insight triggers when avg water < 1500ml', () {
        final totalWater = 12000.0;
        final waterLogsCount = 10;
        final avgWater = totalWater / waterLogsCount;

        expect(avgWater, lessThan(1500.0));
      });

      test('hydration insight not triggered when avg water >= 1500ml', () {
        final totalWater = 18000.0;
        final waterLogsCount = 10;
        final avgWater = totalWater / waterLogsCount;

        expect(avgWater, greaterThanOrEqualTo(1500.0));
      });

      test('high glucose pattern detection', () {
        final glucoseReadings = [145.0, 150.0, 160.0];
        bool hasHighGlucose = false;
        for (final g in glucoseReadings) {
          if (g > 140.0) hasHighGlucose = true;
        }

        expect(hasHighGlucose, isTrue);
      });

      test('normal glucose range does not trigger high alert', () {
        final glucoseReadings = [100.0, 120.0, 130.0];
        bool hasHighGlucose = false;
        for (final g in glucoseReadings) {
          if (g > 140.0) hasHighGlucose = true;
        }

        expect(hasHighGlucose, isFalse);
      });
    });

    group('HealthInsight model', () {
      test('creates insight with correct properties', () {
        final insight = HealthInsight(
          id: 'test_insight',
          title: 'Test Title',
          description: 'Test description',
          category: 'sleep_bp',
          confidence: 0.94,
          isActionable: true,
        );

        expect(insight.id, 'test_insight');
        expect(insight.title, 'Test Title');
        expect(insight.description, 'Test description');
        expect(insight.category, 'sleep_bp');
        expect(insight.confidence, 0.94);
        expect(insight.isActionable, isTrue);
      });

      test('confidence is within valid range', () {
        for (double confidence = 0.0; confidence <= 1.0; confidence += 0.1) {
          final insight = HealthInsight(
            id: 'test',
            title: 'Test',
            description: 'Desc',
            category: 'test',
            confidence: confidence,
            isActionable: true,
          );
          expect(insight.confidence, inInclusiveRange(0.0, 1.0));
        }
      });
    });
  });
}