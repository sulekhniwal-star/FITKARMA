class AW {
  // Project
  static const projectId = String.fromEnvironment('APPWRITE_PROJECT_ID', defaultValue: 'fitkarma-dev');
  static const endpoint = String.fromEnvironment('APPWRITE_ENDPOINT', defaultValue: 'https://cloud.appwrite.io/v1');
  static const dbId = String.fromEnvironment('APPWRITE_DATABASE_ID', defaultValue: 'main_db');

  // Core collections
  static const users            = 'users';
  static const foodLogs         = 'food_logs';
  static const foodItems        = 'food_items';
  static const workoutLogs      = 'workout_logs';
  static const stepLogs         = 'step_logs';
  static const sleepLogs        = 'sleep_logs';
  static const moodLogs         = 'mood_logs';
  static const periodLogs       = 'period_logs';
  static const medications      = 'medications';
  static const habits           = 'habits';
  static const bodyMeasurements = 'body_measurements';
  static const karmaTx          = 'karma_transactions';
  static const nutritionGoals   = 'nutrition_goals';
  static const posts            = 'posts';
  static const challenges       = 'challenges';
  static const subscriptions    = 'subscriptions';
  static const familyGroups     = 'family_groups';
  static const workouts         = 'workouts';

  // Extended collections
  static const bloodPressureLogs  = 'blood_pressure_logs';
  static const glucoseLogs        = 'glucose_logs';
  static const spo2Logs           = 'spo2_logs';
  static const doctorAppointments = 'doctor_appointments';
  static const fastingLogs        = 'fasting_logs';
  static const mealPlans          = 'meal_plans';
  static const recipes            = 'recipes';
  static const journalEntries     = 'journal_entries';
  static const personalRecords    = 'personal_records';
  static const communityGroups    = 'community_groups';
  static const healthReports      = 'health_reports';
  static const communityDms       = 'community_dms';

  // Storage Buckets
  static const avatarsBucket   = 'avatars';
  static const postsBucket     = 'posts_media';
}
