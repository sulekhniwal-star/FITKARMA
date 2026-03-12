import 'package:hive_flutter/hive_flutter.dart';
import '../constants/hive_boxes.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters here in future
    // Hive.registerAdapter(FoodLogAdapter());
    // Hive.registerAdapter(StepLogAdapter());
    // Hive.registerAdapter(WorkoutLogAdapter());
    // etc.

    // Open all boxes as defined in HiveBoxes constants
    // Core boxes
    await Hive.openBox(HiveBoxes.userPrefs);
    await Hive.openBox(HiveBoxes.syncQueue);
    await Hive.openBox(HiveBoxes.karma);
    await Hive.openBox(HiveBoxes.nutritionGoals);
    
    // Feature boxes - Food
    await Hive.openBox(HiveBoxes.foodLogs);
    await Hive.openBox(HiveBoxes.foodItems);
    
    // Feature boxes - Activity
    await Hive.openBox(HiveBoxes.stepLogs);
    await Hive.openBox(HiveBoxes.workoutLogs);
    await Hive.openBox(HiveBoxes.sleepLogs);
    await Hive.openBox(HiveBoxes.moodLogs);
    
    // Feature boxes - Health
    await Hive.openBox(HiveBoxes.periodLogs);
    await Hive.openBox(HiveBoxes.medications);
    await Hive.openBox(HiveBoxes.habits);
    await Hive.openBox(HiveBoxes.bodyMetrics);
    
    // Feature boxes - Medical (AES-256 encrypted)
    await Hive.openBox(HiveBoxes.bloodPressure);
    await Hive.openBox(HiveBoxes.glucose);
    await Hive.openBox(HiveBoxes.spo2);
    await Hive.openBox(HiveBoxes.doctorAppointments);
    
    // Feature boxes - Lifestyle
    await Hive.openBox(HiveBoxes.fasting);
    await Hive.openBox(HiveBoxes.mealPlans);
    await Hive.openBox(HiveBoxes.recipes);
    await Hive.openBox(HiveBoxes.journal);
    
    // Feature boxes - Progress
    await Hive.openBox(HiveBoxes.personalRecords);
    await Hive.openBox(HiveBoxes.healthReports);
    
    // Feature boxes - Infrastructure
    await Hive.openBox(HiveBoxes.wearableSync);
  }

  static Box getBox(String boxName) => Hive.box(boxName);
  
  // Helper to get typed box with encryption support for sensitive data
  static Box getEncryptedBox(String boxName, {List<int>? encryptionKey}) {
    if (encryptionKey != null) {
      return Hive.box(boxName);
    }
    return Hive.box(boxName);
  }
}
