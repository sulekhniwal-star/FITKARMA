import 'package:hive_flutter/hive_flutter.dart';
import '../network/sync_queue_item.dart';
import '../../features/tracking/domain/models/activity_log.dart';
import '../../features/tracking/domain/models/water_log.dart';
import '../../features/food/domain/models/food_item.dart';
import '../../features/food/domain/models/meal_log.dart';
import '../../features/ayurveda/domain/models/dosha_profile.dart';
import '../../features/gamification/domain/models/user_progress.dart';
import '../../features/challenges/domain/models/challenge.dart';
import '../security/encryption_service.dart';

class HiveService {
  static HiveAesCipher? _cipher;

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Setup Encryption
    final key = await EncryptionService.getOrCreateMasterKey();
    _cipher = HiveAesCipher(key);

    // Register Adapters
    Hive.registerAdapter(SyncQueueItemAdapter());
    Hive.registerAdapter(ActivityLogAdapter());
    Hive.registerAdapter(WaterLogAdapter());
    Hive.registerAdapter(FoodItemAdapter());
    Hive.registerAdapter(MealLogAdapter());
    Hive.registerAdapter(DoshaProfileAdapter());
    Hive.registerAdapter(UserProgressAdapter());
    Hive.registerAdapter(ChallengeAdapter());

    await openBox<UserProgress>('user_progress');
    await openBox<DoshaProfile>('dosha_profile');
    await openBox<Challenge>('challenges');

    await _seedFoodData();
    await _seedChallenges();
  }

  static Future<void> _seedChallenges() async {
    final box = await Hive.openBox<Challenge>('challenges');
    if (box.isEmpty) {
      final initialChallenges = [
        Challenge(
          id: 'navratri_satvik',
          titleEn: '7-Day Satvik Challenge',
          titleHi: '7 दिवसीय सात्विक चुनौती',
          xpReward: 500,
          isJoined: false,
          imageUrl: 'https://images.unsplash.com/photo-1626777553732-48993aba357e?auto=format&fit=crop&q=80&w=400',
        ),
        Challenge(
          id: 'yoga_morning',
          titleEn: 'Morning Yoga Sadhana',
          titleHi: 'सुबह का योगाभ्यास',
          xpReward: 300,
          isJoined: false,
          imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&q=80&w=400',
        ),
      ];
      for (var c in initialChallenges) {
        await box.put(c.id, c);
      }
    }
  }

  static Future<void> _seedFoodData() async {
    final foodBox = await Hive.openBox<FoodItem>('food_items');
    if (foodBox.isEmpty) {
      final initialFoods = [
        FoodItem(
          id: 'dal_tadka',
          nameEn: 'Dal Tadka',
          nameHi: 'दाल तड़का',
          caloriesPer100g: 100,
          protein: 5.0,
          carbs: 12.0,
          fat: 3.5,
          imageUrl: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&q=80&w=400',
          portionMultipliers: {'katori': 1.5, 'ladle': 0.5, 'gram': 0.01},
        ),
        FoodItem(
          id: 'roti',
          nameEn: 'Whole Wheat Roti',
          nameHi: 'रोटी',
          caloriesPer100g: 260,
          protein: 9.0,
          carbs: 50.0,
          fat: 3.0,
          imageUrl: 'https://images.unsplash.com/photo-1590301157890-4810ed352733?auto=format&fit=crop&q=80&w=400',
          portionMultipliers: {'piece': 0.7, 'gram': 0.01},
        ),
        FoodItem(
          id: 'paneer_butter_masala',
          nameEn: 'Paneer Butter Masala',
          nameHi: 'पनीर बटर मसाला',
          caloriesPer100g: 200,
          protein: 8.0,
          carbs: 10.0,
          fat: 15.0,
          imageUrl: 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&q=80&w=400',
          portionMultipliers: {'katori': 2.0, 'ladle': 0.8, 'gram': 0.01},
        ),
        FoodItem(
          id: 'masala_dosa',
          nameEn: 'Masala Dosa',
          nameHi: 'मसाला डोसा',
          caloriesPer100g: 170,
          protein: 4.0,
          carbs: 30.0,
          fat: 5.0,
          imageUrl: 'https://images.unsplash.com/photo-1630383249896-424e482df921?auto=format&fit=crop&q=80&w=400',
          portionMultipliers: {'piece': 2.5, 'gram': 0.01},
        ),
        FoodItem(
          id: 'idli',
          nameEn: 'Idli',
          nameHi: 'इडली',
          caloriesPer100g: 130,
          protein: 4.0,
          carbs: 28.0,
          fat: 0.5,
          imageUrl: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&q=80&w=400',
          portionMultipliers: {'piece': 0.4, 'gram': 0.01},
        ),
      ];

      for (var food in initialFoods) {
        await foodBox.put(food.id, food);
      }
    }
  }

  // Helper method to open a box with global encryption cipher
  static Future<Box<T>> openBox<T>(String boxName) async {
    return await Hive.openBox<T>(
      boxName,
      encryptionCipher: _cipher,
    );
  }
}
