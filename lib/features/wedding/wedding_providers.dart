import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WeddingMilestone {
  final String title;
  final String description;
  final int targetDaysOut;
  final bool isCompleted;

  WeddingMilestone({
    required this.title,
    required this.description,
    required this.targetDaysOut,
    this.isCompleted = false,
  });

  WeddingMilestone copyWith({bool? isCompleted}) {
    return WeddingMilestone(
      title: title,
      description: description,
      targetDaysOut: targetDaysOut,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class WeddingMealPlan {
  final String phaseName;
  final String focalNutrients;
  final String suggestions;

  WeddingMealPlan({
    required this.phaseName,
    required this.focalNutrients,
    required this.suggestions,
  });
}

class WeddingState {
  final DateTime weddingDate;
  final List<WeddingMilestone> milestones;
  final List<WeddingMealPlan> mealPlans;

  WeddingState({
    required this.weddingDate,
    required this.milestones,
    required this.mealPlans,
  });

  int get daysRemaining {
    final now = DateTime.now();
    final diff = weddingDate.difference(DateTime(now.year, now.month, now.day)).inDays;
    return diff < 0 ? 0 : diff;
  }
}

class WeddingNotifier extends Notifier<WeddingState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _dateKey = 'user_configured_wedding_date';
  static const _completedMilestonesKey = 'wedding_completed_milestones_ids';

  @override
  WeddingState build() {
    Future.microtask(() => _loadState());
    return _defaultState();
  }

  static WeddingState _defaultState() {
    final target = DateTime.now().add(const Duration(days: 120));
    return WeddingState(
      weddingDate: target,
      milestones: [
        WeddingMilestone(
          title: 'Posture Foundation & Mobility',
          description: 'Focus on daily spinal alignment workouts to build majestic carriage and upper back definition.',
          targetDaysOut: 120,
        ),
        WeddingMilestone(
          title: 'Lean Core & High Intensity Splits',
          description: 'Incorporate 3x weekly progressive HIIT circuits combined with targeted deep abdominal vacuum sets.',
          targetDaysOut: 90,
        ),
        WeddingMilestone(
          title: 'Cardio Glow & Endurance Peaks',
          description: 'Sustain moderate heart-rate walking routines ensuring continuous calorie optimization and pristine stamina.',
          targetDaysOut: 60,
        ),
        WeddingMilestone(
          title: 'Deep Recovery & Anti-Bloat Tapering',
          description: 'Transition to Yin yoga stretching alongside complete elimination of ultra-processed sodium loads.',
          targetDaysOut: 30,
        ),
      ],
      mealPlans: [
        WeddingMealPlan(
          phaseName: 'Deep Hydration & Skin Glow Array',
          focalNutrients: 'Vitamin C, Omega-3 Fatty Acids, Antioxidants',
          suggestions: 'Fresh local amla shots early morning, soaked walnuts, unpolished red rice with local palak saag, hot turmeric infusions.',
        ),
        WeddingMealPlan(
          phaseName: 'Lean Definition & Muscle Tone Protocol',
          focalNutrients: 'High Bioavailable Proteins, Complex Carbs',
          suggestions: 'Grilled paneer/tofu tikka bowls, mixed lentil dosas with mint chutney, overnight chia puddings infused with pure saffron.',
        ),
        WeddingMealPlan(
          phaseName: 'Digestive Ease & De-Puffing Menu',
          focalNutrients: 'Potassium, Soluble Fiber, Probiotics',
          suggestions: 'Fresh coconut water bases, warm jeera water, steamed bottle gourd soup, light homemade curd with cucumber shreds.',
        ),
      ],
    );
  }

  Future<void> _loadState() async {
    try {
      final dateStr = await _storage.read(key: _dateKey);
      DateTime loadedDate = state.weddingDate;
      if (dateStr != null) {
        final d = DateTime.tryParse(dateStr);
        if (d != null) loadedDate = d;
      }

      final compStr = await _storage.read(key: _completedMilestonesKey);
      List<String> completedTitles = [];
      if (compStr != null) {
        final list = jsonDecode(compStr) as List<dynamic>;
        completedTitles = list.map((e) => e.toString()).toList();
      }

      final mappedMilestones = state.milestones.map((m) {
        return m.copyWith(isCompleted: completedTitles.contains(m.title));
      }).toList();

      state = WeddingState(
        weddingDate: loadedDate,
        milestones: mappedMilestones,
        mealPlans: state.mealPlans,
      );
    } catch (_) {}
  }

  Future<void> updateWeddingDate(DateTime newDate) async {
    state = WeddingState(
      weddingDate: newDate,
      milestones: state.milestones,
      mealPlans: state.mealPlans,
    );
    try {
      await _storage.write(key: _dateKey, value: newDate.toIso8601String());
    } catch (_) {}
  }

  Future<void> toggleMilestone(String title) async {
    final updated = state.milestones.map((m) {
      if (m.title == title) {
        return m.copyWith(isCompleted: !m.isCompleted);
      }
      return m;
    }).toList();

    state = WeddingState(
      weddingDate: state.weddingDate,
      milestones: updated,
      mealPlans: state.mealPlans,
    );

    try {
      final completed = updated.where((e) => e.isCompleted).map((e) => e.title).toList();
      await _storage.write(key: _completedMilestonesKey, value: jsonEncode(completed));
    } catch (_) {}
  }
}

final weddingPlannerProvider = NotifierProvider<WeddingNotifier, WeddingState>(WeddingNotifier.new);
