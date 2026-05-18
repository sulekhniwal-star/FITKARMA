import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/onboarding/models/dosha_quiz.dart';

void main() {
  DoshaResult computeDosha(Map<int, DoshaType> answers) {
    if (answers.length < 10) {
      throw ArgumentError('All 10 questions must be answered');
    }

    int vata = 0, pitta = 0, kapha = 0;
    for (final answer in answers.values) {
      if (answer == DoshaType.vata) vata++;
      if (answer == DoshaType.pitta) pitta++;
      if (answer == DoshaType.kapha) kapha++;
    }

    final total = answers.length.toDouble();

    DoshaType dominant = DoshaType.vata;
    if (pitta >= vata && pitta >= kapha) dominant = DoshaType.pitta;
    if (kapha >= vata && kapha >= pitta) dominant = DoshaType.kapha;

    return DoshaResult(
      dominant: dominant,
      vataPercentage: (vata / total) * 100,
      pittaPercentage: (pitta / total) * 100,
      kaphaPercentage: (kapha / total) * 100,
    );
  }

  group('computeDosha - all 10-question permutations', () {
    test('all vata answers results in dominant vata', () {
      final answers = Map.fromEntries(List.generate(10, (i) => MapEntry(i, DoshaType.vata)));
      final result = computeDosha(answers);

      expect(result.dominant, DoshaType.vata);
      expect(result.vataPercentage, 100.0);
      expect(result.pittaPercentage, 0.0);
      expect(result.kaphaPercentage, 0.0);
    });

    test('all pitta answers results in dominant pitta', () {
      final answers = Map.fromEntries(List.generate(10, (i) => MapEntry(i, DoshaType.pitta)));
      final result = computeDosha(answers);

      expect(result.dominant, DoshaType.pitta);
      expect(result.vataPercentage, 0.0);
      expect(result.pittaPercentage, 100.0);
      expect(result.kaphaPercentage, 0.0);
    });

    test('all kapha answers results in dominant kapha', () {
      final answers = Map.fromEntries(List.generate(10, (i) => MapEntry(i, DoshaType.kapha)));
      final result = computeDosha(answers);

      expect(result.dominant, DoshaType.kapha);
      expect(result.vataPercentage, 0.0);
      expect(result.pittaPercentage, 0.0);
      expect(result.kaphaPercentage, 100.0);
    });

    test('equal split (4-3-3) defaults to first alphabetical dominant', () {
      final answers = <int, DoshaType>{
        0: DoshaType.vata, 1: DoshaType.vata, 2: DoshaType.vata, 3: DoshaType.vata,
        4: DoshaType.pitta, 5: DoshaType.pitta, 6: DoshaType.pitta,
        7: DoshaType.kapha, 8: DoshaType.kapha, 9: DoshaType.kapha,
      };
      final result = computeDosha(answers);

      expect(result.vataPercentage, 40.0);
      expect(result.pittaPercentage, 30.0);
      expect(result.kaphaPercentage, 30.0);
      expect(result.dominant, DoshaType.vata);
    });

    test('equal split vata-pitta results in pitta dominant', () {
      final answers = <int, DoshaType>{
        0: DoshaType.vata, 1: DoshaType.vata, 2: DoshaType.vata, 3: DoshaType.vata,
        4: DoshaType.pitta, 5: DoshaType.pitta, 6: DoshaType.pitta, 7: DoshaType.pitta,
        8: DoshaType.kapha, 9: DoshaType.kapha,
      };
      final result = computeDosha(answers);

      expect(result.dominant, DoshaType.pitta);
      expect(result.vataPercentage, 40.0);
      expect(result.pittaPercentage, 40.0);
      expect(result.kaphaPercentage, 20.0);
    });

    test('equal split vata-kapha results in kapha dominant', () {
      final answers = <int, DoshaType>{
        0: DoshaType.vata, 1: DoshaType.vata, 2: DoshaType.vata, 3: DoshaType.vata,
        4: DoshaType.kapha, 5: DoshaType.kapha, 6: DoshaType.kapha, 7: DoshaType.kapha,
        8: DoshaType.pitta, 9: DoshaType.pitta,
      };
      final result = computeDosha(answers);

      expect(result.dominant, DoshaType.kapha);
      expect(result.vataPercentage, 40.0);
      expect(result.pittaPercentage, 20.0);
      expect(result.kaphaPercentage, 40.0);
    });

    test('equal three-way tie (4-3-3) - kapha wins when all equal', () {
      final answers = <int, DoshaType>{
        0: DoshaType.kapha, 1: DoshaType.kapha, 2: DoshaType.kapha, 3: DoshaType.kapha,
        4: DoshaType.vata, 5: DoshaType.vata, 6: DoshaType.vata, 7: DoshaType.vata,
        8: DoshaType.pitta, 9: DoshaType.pitta,
      };
      final result = computeDosha(answers);
      expect(result.dominant, DoshaType.kapha);
    });

    test('single vata majority results in vata dominant', () {
      final answers = <int, DoshaType>{
        0: DoshaType.vata, 1: DoshaType.vata, 2: DoshaType.vata, 3: DoshaType.vata, 4: DoshaType.vata,
        5: DoshaType.vata, 6: DoshaType.pitta, 7: DoshaType.pitta, 8: DoshaType.kapha, 9: DoshaType.kapha,
      };
      final result = computeDosha(answers);

      expect(result.dominant, DoshaType.vata);
      expect(result.vataPercentage, 60.0);
      expect(result.pittaPercentage, 20.0);
      expect(result.kaphaPercentage, 20.0);
    });

    test('single pitta majority results in pitta dominant', () {
      final answers = <int, DoshaType>{
        0: DoshaType.pitta, 1: DoshaType.pitta, 2: DoshaType.pitta, 3: DoshaType.pitta, 4: DoshaType.pitta,
        5: DoshaType.pitta, 6: DoshaType.vata, 7: DoshaType.vata, 8: DoshaType.kapha, 9: DoshaType.kapha,
      };
      final result = computeDosha(answers);

      expect(result.dominant, DoshaType.pitta);
      expect(result.vataPercentage, 20.0);
      expect(result.pittaPercentage, 60.0);
      expect(result.kaphaPercentage, 20.0);
    });

    test('single kapha majority results in kapha dominant', () {
      final answers = <int, DoshaType>{
        0: DoshaType.kapha, 1: DoshaType.kapha, 2: DoshaType.kapha, 3: DoshaType.kapha, 4: DoshaType.kapha,
        5: DoshaType.kapha, 6: DoshaType.vata, 7: DoshaType.vata, 8: DoshaType.pitta, 9: DoshaType.pitta,
      };
      final result = computeDosha(answers);

      expect(result.dominant, DoshaType.kapha);
      expect(result.vataPercentage, 20.0);
      expect(result.pittaPercentage, 20.0);
      expect(result.kaphaPercentage, 60.0);
    });

    test('throws when fewer than 10 questions answered', () {
      final answers = <int, DoshaType>{0: DoshaType.vata, 1: DoshaType.pitta};
      expect(() => computeDosha(answers), throwsArgumentError);
    });

    test('toString format is correct', () {
      final answers = Map.fromEntries(List.generate(10, (i) => MapEntry(i, DoshaType.vata)));
      final result = computeDosha(answers);
      expect(result.toString(), contains('VATA'));
      expect(result.toString(), contains('V: 100%'));
    });
  });
}