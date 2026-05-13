import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/core_providers.dart';
import 'karma_providers.dart';

class KarmaService {
  final Functions _functions;
  final KarmaNotifier _karmaNotifier;

  static const Map<String, Map<String, dynamic>> _eventDefinitions = {
    'food_log': {'title': 'Logged Meal Item', 'category': 'food', 'xp': 5},
    'food_log_complete': {'title': 'Complete Daily Nutrition', 'category': 'food', 'xp': 20},
    'workout_complete': {'title': 'Completed Exercise Session', 'category': 'workout', 'xp': 30},
    'steps_goal': {'title': 'Attained Daily Step Target', 'category': 'steps', 'xp': 25},
    'sleep_logged': {'title': 'Logged Sleep Recovery Log', 'category': 'streak', 'xp': 10},
    'bp_reading': {'title': 'Recorded Blood Pressure', 'category': 'streak', 'xp': 10},
    'glucose_reading': {'title': 'Logged Glucose Marker', 'category': 'streak', 'xp': 10},
    'habit_complete': {'title': 'Checked Off Daily Habit', 'category': 'streak', 'xp': 15},
    'journal_entry': {'title': 'Wrote Reflective Journal Entry', 'category': 'streak', 'xp': 10},
    'streak_7day': {'title': '7-Day Continuous Streak', 'category': 'streak', 'xp': 50},
    'streak_30day': {'title': '30-Day Epic Consistency', 'category': 'streak', 'xp': 150},
    'lab_report': {'title': 'Uploaded Clinical Lab Report', 'category': 'streak', 'xp': 20},
    'referral': {'title': 'Invited a Peer Participant', 'category': 'streak', 'xp': 500},
  };

  KarmaService(this._functions, this._karmaNotifier);

  Future<void> awardXP(String eventType) async {
    final def = _eventDefinitions[eventType];
    if (def == null) return;

    final String title = def['title'] as String;
    final String category = def['category'] as String;
    final int xp = def['xp'] as int;

    // 1. Immediately apply optimistic XP awards locally
    _karmaNotifier.addKarmaEvent(title, category, xp);

    // 2. Invoke remote serverless container tracking function asynchronously
    try {
      await _functions.createExecution(
        functionId: 'xp-calculator',
        body: jsonEncode({
          'eventType': eventType,
          'xpAwarded': xp,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
    } catch (_) {
      // Silently gracefully degrade if offline/sandbox mode is operational
    }
  }
}

final karmaServiceProvider = Provider<KarmaService>((ref) {
  final client = ref.watch(appwriteClientProvider);
  final notifier = ref.read(karmaStateProvider.notifier);
  return KarmaService(Functions(client), notifier);
});
