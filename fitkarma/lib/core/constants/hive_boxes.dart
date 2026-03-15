// lib/core/constants/hive_boxes.dart

/// Hive box names - used for local storage
class HiveBoxes {
  // Core boxes
  static const String foodLogs = 'food_logs_box';
  static const String stepLogs = 'step_logs_box';
  static const String workoutLogs = 'workout_logs_box';
  static const String sleepLogs = 'sleep_logs_box';
  static const String moodLogs = 'mood_logs_box';

  // Encrypted boxes (sensitive health data)
  static const String periodLogs = 'period_logs_box';
  static const String bloodPressure = 'blood_pressure_box';
  static const String glucose = 'glucose_box';
  static const String journal = 'journal_box';
  static const String doctorAppointments = 'doctor_appointments_box';

  // Other health data
  static const String medications = 'medications_box';
  static const String habits = 'habits_box';
  static const String bodyMetrics = 'body_metrics_box';
  static const String spo2 = 'spo2_box';
  static const String fasting = 'fasting_box';

  // Cache & sync
  static const String foodItems = 'food_items_box';
  static const String syncQueue = 'sync_queue_box';
  static const String wearableSync = 'wearable_sync_box';

  // User data
  static const String userPrefs = 'user_prefs_box';
  static const String karma = 'karma_box';
  static const String nutritionGoals = 'nutrition_goals_box';

  // Extended features
  static const String mealPlans = 'meal_plans_box';
  static const String recipes = 'recipes_box';
  static const String personalRecords = 'personal_records_box';
  static const String healthReports = 'health_reports_box';
}
