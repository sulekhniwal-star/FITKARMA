import 'package:flutter_test/flutter_test.dart';

int computeLevel(int xp) {
  final lvl = (xp ~/ 600) + 1;
  return lvl > 13 ? 13 : lvl;
}

int nextLevelTarget(int level) {
  return level * 600;
}

String getLevelTitle(int level) {
  const names = [
    'Newcomer',
    'Beginner',
    'Starter',
    'Mover',
    'Achiever',
    'Consistent',
    'Dedicated',
    'Warrior',
    'Champion',
    'Elite',
    'Legend',
    'Grandmaster',
    'Karma Master',
  ];
  if (level <= 0) return names.first;
  if (level > names.length) return names.last;
  return names[level - 1];
}

void main() {
  group('computeLevel - XP thresholds for all 13 levels', () {
    test('Level 1: 0-599 XP', () {
      expect(computeLevel(0), 1);
      expect(computeLevel(100), 1);
      expect(computeLevel(599), 1);
    });

    test('Level 2: 600-1199 XP', () {
      expect(computeLevel(600), 2);
      expect(computeLevel(800), 2);
      expect(computeLevel(1199), 2);
    });

    test('Level 3: 1200-1799 XP', () {
      expect(computeLevel(1200), 3);
      expect(computeLevel(1500), 3);
      expect(computeLevel(1799), 3);
    });

    test('Level 4: 1800-2399 XP', () {
      expect(computeLevel(1800), 4);
      expect(computeLevel(2100), 4);
      expect(computeLevel(2399), 4);
    });

    test('Level 5: 2400-2999 XP', () {
      expect(computeLevel(2400), 5);
      expect(computeLevel(2700), 5);
      expect(computeLevel(2999), 5);
    });

    test('Level 6: 3000-3599 XP', () {
      expect(computeLevel(3000), 6);
      expect(computeLevel(3300), 6);
      expect(computeLevel(3599), 6);
    });

    test('Level 7: 3600-4199 XP', () {
      expect(computeLevel(3600), 7);
      expect(computeLevel(3900), 7);
      expect(computeLevel(4199), 7);
    });

    test('Level 8: 4200-4799 XP', () {
      expect(computeLevel(4200), 8);
      expect(computeLevel(4500), 8);
      expect(computeLevel(4799), 8);
    });

    test('Level 9: 4800-5399 XP', () {
      expect(computeLevel(4800), 9);
      expect(computeLevel(5100), 9);
      expect(computeLevel(5399), 9);
    });

    test('Level 10: 5400-5999 XP', () {
      expect(computeLevel(5400), 10);
      expect(computeLevel(5700), 10);
      expect(computeLevel(5999), 10);
    });

    test('Level 11: 6000-6599 XP', () {
      expect(computeLevel(6000), 11);
      expect(computeLevel(6300), 11);
      expect(computeLevel(6599), 11);
    });

    test('Level 12: 6600-7199 XP', () {
      expect(computeLevel(6600), 12);
      expect(computeLevel(6900), 12);
      expect(computeLevel(7199), 12);
    });

    test('Level 13: 7200+ XP', () {
      expect(computeLevel(7200), 13);
      expect(computeLevel(8000), 13);
      expect(computeLevel(10000), 13);
      expect(computeLevel(100000), 13);
    });

    test('level boundaries are accurate', () {
      for (int level = 1; level <= 13; level++) {
        final minXp = (level - 1) * 600;
        final maxXp = level * 600 - 1;

        expect(computeLevel(minXp), level,
            reason: 'Min XP for level $level should give level $level');
        if (maxXp < 100000) {
          expect(computeLevel(maxXp), level,
              reason: 'Max XP for level $level should give level $level');
        }
      }
    });
  });

  group('nextLevelTarget', () {
    test('returns correct targets for each level', () {
      expect(nextLevelTarget(1), 600);
      expect(nextLevelTarget(2), 1200);
      expect(nextLevelTarget(7), 4200);
      expect(nextLevelTarget(13), 7800);
    });
  });

  group('getLevelTitle', () {
    test('returns correct titles for all 13 levels', () {
      expect(getLevelTitle(1), 'Newcomer');
      expect(getLevelTitle(2), 'Beginner');
      expect(getLevelTitle(3), 'Starter');
      expect(getLevelTitle(4), 'Mover');
      expect(getLevelTitle(5), 'Achiever');
      expect(getLevelTitle(6), 'Consistent');
      expect(getLevelTitle(7), 'Dedicated');
      expect(getLevelTitle(8), 'Warrior');
      expect(getLevelTitle(9), 'Champion');
      expect(getLevelTitle(10), 'Elite');
      expect(getLevelTitle(11), 'Legend');
      expect(getLevelTitle(12), 'Grandmaster');
      expect(getLevelTitle(13), 'Karma Master');
    });

    test('handles invalid levels gracefully', () {
      expect(getLevelTitle(0), 'Newcomer');
      expect(getLevelTitle(-1), 'Newcomer');
      expect(getLevelTitle(14), 'Karma Master');
      expect(getLevelTitle(100), 'Karma Master');
    });
  });
}