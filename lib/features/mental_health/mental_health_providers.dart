import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BreathingExercise {
  final String id;
  final String title;
  final String description;
  final String hindiTitle;
  final int inhaleSeconds;
  final int hold1Seconds;
  final int exhaleSeconds;
  final int hold2Seconds;
  final String colorToken;

  BreathingExercise({
    required this.id,
    required this.title,
    required this.description,
    required this.hindiTitle,
    required this.inhaleSeconds,
    required this.hold1Seconds,
    required this.exhaleSeconds,
    required this.hold2Seconds,
    required this.colorToken,
  });
}

class CbtInsight {
  final String distortion;
  final String hindiDistortion;
  final String definition;
  final String reframing;

  CbtInsight({
    required this.distortion,
    required this.hindiDistortion,
    required this.definition,
    required this.reframing,
  });
}

class MentalHealthState {
  final double burnoutScore; // 1.0 to 10.0
  final List<BreathingExercise> exercises;
  final List<CbtInsight> cbtInsights;

  MentalHealthState({
    required this.burnoutScore,
    required this.exercises,
    required this.cbtInsights,
  });

  String get burnoutLevelLabel {
    if (burnoutScore < 3.5) return 'Low Risk (Resilient)';
    if (burnoutScore < 6.5) return 'Moderate Fatigue';
    if (burnoutScore < 8.5) return 'High Overload';
    return 'Severe Depletion';
  }

  String get burnoutHindiLabel {
    if (burnoutScore < 3.5) return 'कम जोखिम (संतुलित)';
    if (burnoutScore < 6.5) return 'मध्यम तनाव';
    if (burnoutScore < 8.5) return 'अत्यधिक थकान';
    return 'गंभीर मानसिक थकावट';
  }

  factory MentalHealthState.initial() {
    return MentalHealthState(
      burnoutScore: 4.0, // default moderate baseline
      exercises: [
        BreathingExercise(
          id: '4-7-8',
          title: '4-7-8 Sleep Rest',
          hindiTitle: 'गहरी निद्रा श्वास',
          description: 'Activates parasympathetic nervous system to quickly cool anxious autonomic loops.',
          inhaleSeconds: 4,
          hold1Seconds: 7,
          exhaleSeconds: 8,
          hold2Seconds: 0,
          colorToken: 'purple',
        ),
        BreathingExercise(
          id: 'box',
          title: 'Box Breathing (Sama Vritti)',
          hindiTitle: 'समवृत्ति प्राणायाम',
          description: 'Equal durations stabilize heart-rate variability and focus scattered cognitive focus.',
          inhaleSeconds: 4,
          hold1Seconds: 4,
          exhaleSeconds: 4,
          hold2Seconds: 4,
          colorToken: 'teal',
        ),
        BreathingExercise(
          id: '2-1-4-1',
          title: '2-1-4-1 Vagus Reset',
          hindiTitle: 'वेगस नाड़ी विश्राम',
          description: 'Prolonged exhales drop systemic cortisol levels during immediate panic peaks.',
          inhaleSeconds: 2,
          hold1Seconds: 1,
          exhaleSeconds: 4,
          hold2Seconds: 1,
          colorToken: 'accent',
        ),
      ],
      cbtInsights: [
        CbtInsight(
          distortion: 'Catastrophizing',
          hindiDistortion: 'अनर्थ-चिन्तन',
          definition: 'Automatically anticipating the worst possible disaster without empirical evidence.',
          reframing: 'What is the most statistically probable outcome? Have I successfully coped with similar adversity in the past?',
        ),
        CbtInsight(
          distortion: 'All-or-Nothing Thinking',
          hindiDistortion: 'पूर्ण या शून्य सोच',
          definition: 'Evaluating performance in absolute extremes—total success versus irredeemable failure.',
          reframing: 'Progress is continuous and fractional. Can I appreciate incremental steps taken today regardless of perfection?',
        ),
        CbtInsight(
          distortion: 'Emotional Reasoning',
          hindiDistortion: 'भावनात्मक तर्क',
          definition: 'Concluding that intense transient internal feelings represent unquestioned external facts.',
          reframing: 'Feelings are transient chemical signals, not factual objective declarations. Emotions pass like clouds.',
        ),
        CbtInsight(
          distortion: 'Mental Filtering',
          hindiDistortion: 'नकारात्मक फ़िल्टर',
          definition: 'Magnifying a single negative detail while completely screening out ongoing positive context.',
          reframing: 'Let me list three specific positive aspects or neutral buffers operating concurrently in my life right now.',
        ),
      ],
    );
  }
}

class MentalHealthNotifier extends Notifier<MentalHealthState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _storageKey = 'mh_burnout_score';

  @override
  MentalHealthState build() {
    Future.microtask(() => _loadState());
    return MentalHealthState.initial();
  }

  Future<void> _loadState() async {
    try {
      final scoreStr = await _storage.read(key: _storageKey);
      if (scoreStr != null) {
        final double s = double.tryParse(scoreStr) ?? 4.0;
        state = MentalHealthState(
          burnoutScore: s.clamp(1.0, 10.0),
          exercises: state.exercises,
          cbtInsights: state.cbtInsights,
        );
      }
    } catch (_) {}
  }

  Future<void> setBurnoutScore(double score) async {
    final clamped = score.clamp(1.0, 10.0);
    state = MentalHealthState(
      burnoutScore: clamped,
      exercises: state.exercises,
      cbtInsights: state.cbtInsights,
    );
    try {
      await _storage.write(key: _storageKey, value: clamped.toString());
    } catch (_) {}
  }
}

final mentalHealthStateProvider = NotifierProvider<MentalHealthNotifier, MentalHealthState>(MentalHealthNotifier.new);

final selectedBreathingExerciseProvider = StateProvider<BreathingExercise?>((ref) {
  return null;
});
