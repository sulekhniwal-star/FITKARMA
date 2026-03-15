// lib/features/workout/data/workout_aw_service.dart
import 'package:appwrite/appwrite.dart';
import '../../../core/network/appwrite_client.dart';
import '../../../core/constants/app_config.dart';
import '../domain/workout_model.dart';

/// Service for managing workouts in Appwrite
class WorkoutAwService {
  static String get _databaseId => AppConfig.appwriteDatabaseId;
  static const String _workoutsCollectionId = 'workouts';

  /// Seed initial workout data into Appwrite
  static Future<void> seedWorkoutData() async {
    try {
      // Check if workouts already exist
      final existing = await AppwriteClient.databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _workoutsCollectionId,
        queries: [Query.limit(1)],
      );

      if (existing.documents.isNotEmpty) {
        print('Workouts already seeded');
        return;
      }

      // Seed workouts
      final workouts = _getSeedWorkouts();
      for (final workout in workouts) {
        await createWorkout(workout);
      }
      print('Workout data seeded successfully');
    } catch (e) {
      print('Error seeding workout data: $e');
    }
  }

  /// Get seed workouts data
  static List<Workout> _getSeedWorkouts() {
    return [
      // Yoga Workouts
      Workout(
        id: 'yoga_001',
        title: 'Morning Yoga Flow',
        description:
            'Start your day with this energizing yoga sequence. Perfect for beginners looking to establish a morning routine.',
        category: 'yoga',
        youtubeId: '9kOCmB0W5eU',
        durationMinutes: 20,
        difficulty: 'beginner',
        thumbnailUrl:
            'https://img.youtube.com/vi/9kOCmB0W5eU/maxresdefault.jpg',
        tags: ['morning', 'energy', 'flexibility'],
        caloriesBurn: 80,
      ),
      Workout(
        id: 'yoga_002',
        title: 'Power Yoga',
        description:
            'A challenging yoga session that builds strength and endurance. Great for intermediate practitioners.',
        category: 'yoga',
        youtubeId: 'H3B3s4y91Wc',
        durationMinutes: 45,
        difficulty: 'intermediate',
        thumbnailUrl:
            'https://img.youtube.com/vi/H3B3s4y91Wc/maxresdefault.jpg',
        tags: ['strength', 'power', 'core'],
        caloriesBurn: 200,
      ),
      Workout(
        id: 'yoga_003',
        title: 'Evening Relaxation Yoga',
        description:
            'Wind down with this calming yoga sequence designed to help you relax before bed.',
        category: 'yoga',
        youtubeId: 'oX6I6bGdf9M',
        durationMinutes: 25,
        difficulty: 'beginner',
        thumbnailUrl:
            'https://img.youtube.com/vi/oX6I6bGdf9M/maxresdefault.jpg',
        tags: ['evening', 'relaxation', 'sleep'],
        caloriesBurn: 60,
      ),
      // HIIT Workouts
      Workout(
        id: 'hiit_001',
        title: '20-Minute Fat Burn HIIT',
        description:
            'High-intensity interval training to torch calories and boost your metabolism.',
        category: 'hiit',
        youtubeId: 'ml6cT4AZdqI',
        durationMinutes: 20,
        difficulty: 'intermediate',
        thumbnailUrl:
            'https://img.youtube.com/vi/ml6cT4AZdqI/maxresdefault.jpg',
        tags: ['fat burn', 'cardio', 'calories'],
        caloriesBurn: 250,
      ),
      Workout(
        id: 'hiit_002',
        title: 'Beginner HIIT',
        description:
            'Perfect introduction to HIIT for those just starting their fitness journey.',
        category: 'hiit',
        youtubeId: 'y1Pz4g6W5jA',
        durationMinutes: 15,
        difficulty: 'beginner',
        thumbnailUrl:
            'https://img.youtube.com/vi/y1Pz4g6W5jA/maxresdefault.jpg',
        tags: ['beginner', 'intro', 'easy'],
        caloriesBurn: 150,
      ),
      Workout(
        id: 'hiit_003',
        title: 'Advanced Tabata',
        description:
            'Maximum effort Tabata workout for advanced athletes. 4 minutes of pure intensity.',
        category: 'hiit',
        youtubeId: 'jing4Bqt eg',
        durationMinutes: 30,
        difficulty: 'advanced',
        thumbnailUrl:
            'https://img.youtube.com/vi/jing4Bqt%20eg/maxresdefault.jpg',
        tags: ['tabata', 'advanced', 'intense'],
        caloriesBurn: 350,
      ),
      // Strength Workouts
      Workout(
        id: 'strength_001',
        title: 'Full Body Strength',
        description:
            'Complete strength training targeting all major muscle groups. No equipment needed.',
        category: 'strength',
        youtubeId: 'F2kuiHq3eRQ',
        durationMinutes: 35,
        difficulty: 'intermediate',
        thumbnailUrl:
            'https://img.youtube.com/vi/F2kuiHq3eRQ/maxresdefault.jpg',
        tags: ['full body', 'muscle', 'strength'],
        caloriesBurn: 220,
      ),
      Workout(
        id: 'strength_002',
        title: 'Upper Body Blast',
        description:
            'Focus on building upper body strength with this targeted workout.',
        category: 'strength',
        youtubeId: 'VwqC3N3R9gY',
        durationMinutes: 25,
        difficulty: 'intermediate',
        thumbnailUrl:
            'https://img.youtube.com/vi/VwqC3N3R9gY/maxresdefault.jpg',
        tags: ['upper body', 'arms', 'chest', 'back'],
        caloriesBurn: 180,
      ),
      Workout(
        id: 'strength_003',
        title: 'Core & Abs Workout',
        description:
            'Strong core is the foundation. Build ab strength with this focused routine.',
        category: 'strength',
        youtubeId: '1f8yoFFdkcY',
        durationMinutes: 15,
        difficulty: 'beginner',
        thumbnailUrl:
            'https://img.youtube.com/vi/1f8yoFFdkcY/maxresdefault.jpg',
        tags: ['core', 'abs', 'belly fat'],
        caloriesBurn: 100,
      ),
      // Dance Workouts
      Workout(
        id: 'dance_001',
        title: 'Bollywood Dance Workout',
        description:
            'Fun Bollywood-inspired dance workout to get your heart pumping. No dance experience needed!',
        category: 'dance',
        youtubeId: 'Xu4WvZ3pYjA',
        durationMinutes: 30,
        difficulty: 'beginner',
        thumbnailUrl:
            'https://img.youtube.com/vi/Xu4WvZ3pYjA/maxresdefault.jpg',
        tags: ['bollywood', 'fun', 'dance'],
        caloriesBurn: 200,
      ),
      Workout(
        id: 'dance_002',
        title: 'Hip Hop Dance Cardio',
        description: 'Learn cool hip hop moves while burning major calories.',
        category: 'dance',
        youtubeId: 'q19cN3KiYlA',
        durationMinutes: 35,
        difficulty: 'intermediate',
        thumbnailUrl:
            'https://img.youtube.com/vi/q19cN3KiYlA/maxresdefault.jpg',
        tags: ['hip hop', 'urban', 'cool'],
        caloriesBurn: 280,
      ),
      // Bollywood Workouts
      Workout(
        id: 'bollywood_001',
        title: 'Bollywood Fitness Mashup',
        description:
            'Combine Bollywood dance moves with fitness exercises for a fun, effective workout.',
        category: 'bollywood',
        youtubeId: '7B2RrN7f5jU',
        durationMinutes: 40,
        difficulty: 'intermediate',
        thumbnailUrl:
            'https://img.youtube.com/vi/7B2RrN7f5jU/maxresdefault.jpg',
        tags: ['bollywood', 'fitness', 'fun'],
        caloriesBurn: 250,
      ),
      Workout(
        id: 'bollywood_002',
        title: 'Easy Bollywood Steps',
        description:
            'Learn simple Bollywood steps you can do at home. Perfect for beginners.',
        category: 'bollywood',
        youtubeId: 'jqKk8p3XbFc',
        durationMinutes: 20,
        difficulty: 'beginner',
        thumbnailUrl:
            'https://img.youtube.com/vi/jqKk8p3XbFc/maxresdefault.jpg',
        tags: ['easy', 'beginner', 'steps'],
        caloriesBurn: 120,
      ),
      // Pranayama
      Workout(
        id: 'pranayama_001',
        title: 'Breathing Basics',
        description:
            'Learn the fundamentals of Pranayama breathing techniques for stress relief.',
        category: 'pranayama',
        youtubeId: 'Yq3_9_tYlE0',
        durationMinutes: 15,
        difficulty: 'beginner',
        thumbnailUrl:
            'https://img.youtube.com/vi/Yq3_9_tYlE0/maxresdefault.jpg',
        tags: ['breathing', 'stress relief', 'relaxation'],
        caloriesBurn: 20,
      ),
      Workout(
        id: 'pranayama_002',
        title: 'Advanced Pranayama',
        description: 'Deep breathing techniques for experienced practitioners.',
        category: 'pranayama',
        youtubeId: 'Xq1aN3mN8aM',
        durationMinutes: 25,
        difficulty: 'advanced',
        thumbnailUrl:
            'https://img.youtube.com/vi/Xq1aN3mN8aM/maxresdefault.jpg',
        tags: ['advanced', 'deep breathing', 'energy'],
        caloriesBurn: 40,
      ),
      // Cardio
      Workout(
        id: 'cardio_001',
        title: 'Jump Rope Cardio',
        description:
            'High-energy jump rope workout to improve cardiovascular fitness.',
        category: 'cardio',
        youtubeId: 's3M7eL3B3aU',
        durationMinutes: 20,
        difficulty: 'intermediate',
        thumbnailUrl:
            'https://img.youtube.com/vi/s3M7eL3B3aU/maxresdefault.jpg',
        tags: ['jump rope', 'cardio', 'coordination'],
        caloriesBurn: 280,
      ),
      Workout(
        id: 'cardio_002',
        title: 'Low Impact Cardio',
        description: 'Effective cardio workout that is gentle on your joints.',
        category: 'cardio',
        youtubeId: 'kYc8b3Z5tFw',
        durationMinutes: 25,
        difficulty: 'beginner',
        thumbnailUrl:
            'https://img.youtube.com/vi/kYc8b3Z5tFw/maxresdefault.jpg',
        tags: ['low impact', 'joint friendly', 'beginner'],
        caloriesBurn: 150,
      ),
      // Stretching
      Workout(
        id: 'stretching_001',
        title: 'Full Body Stretch',
        description:
            'Complete stretching routine to improve flexibility and prevent injury.',
        category: 'stretching',
        youtubeId: 'UXJrBGkyP3I',
        durationMinutes: 20,
        difficulty: 'beginner',
        thumbnailUrl:
            'https://img.youtube.com/vi/UXJrBGkyP3I/maxresdefault.jpg',
        tags: ['flexibility', 'stretch', 'recovery'],
        caloriesBurn: 50,
      ),
      Workout(
        id: 'stretching_002',
        title: 'Morning Wake Up Stretch',
        description:
            'Gentle stretches to wake up your body and prepare for the day.',
        category: 'stretching',
        youtubeId: 'aL8KmyXz7Yc',
        durationMinutes: 10,
        difficulty: 'beginner',
        thumbnailUrl:
            'https://img.youtube.com/vi/aL8KmyXz7Yc/maxresdefault.jpg',
        tags: ['morning', 'wake up', 'gentle'],
        caloriesBurn: 30,
      ),
      // Outdoor
      Workout(
        id: 'outdoor_001',
        title: 'Outdoor Running Guide',
        description:
            'Tips and guidance for outdoor running workouts. Track your route with GPS.',
        category: 'outdoor',
        youtubeId: 'n3k8WBxWq5s',
        durationMinutes: 30,
        difficulty: 'intermediate',
        thumbnailUrl:
            'https://img.youtube.com/vi/n3k8WBxWq5s/maxresdefault.jpg',
        tags: ['running', 'outdoor', 'gps'],
        caloriesBurn: 300,
      ),
    ];
  }

  /// Create a workout in Appwrite
  static Future<String?> createWorkout(Workout workout) async {
    try {
      final response = await AppwriteClient.databases.createDocument(
        databaseId: _databaseId,
        collectionId: _workoutsCollectionId,
        documentId: workout.id,
        data: workout.toAppwrite(),
      );
      return response.$id;
    } catch (e) {
      print('Error creating workout: $e');
      return null;
    }
  }

  /// Get all workouts from Appwrite
  static Future<List<Workout>> getAllWorkouts() async {
    try {
      final response = await AppwriteClient.databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _workoutsCollectionId,
      );

      return response.documents.map((doc) {
        return Workout.fromAppwrite(doc.data, doc.$id);
      }).toList();
    } catch (e) {
      print('Error fetching workouts: $e');
      return [];
    }
  }

  /// Get workouts by category
  static Future<List<Workout>> getWorkoutsByCategory(String category) async {
    try {
      final response = await AppwriteClient.databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _workoutsCollectionId,
        queries: [Query.equal('category', category)],
      );

      return response.documents.map((doc) {
        return Workout.fromAppwrite(doc.data, doc.$id);
      }).toList();
    } catch (e) {
      print('Error fetching workouts by category: $e');
      return [];
    }
  }

  /// Get workout by ID
  static Future<Workout?> getWorkoutById(String id) async {
    try {
      final response = await AppwriteClient.databases.getDocument(
        databaseId: _databaseId,
        collectionId: _workoutsCollectionId,
        documentId: id,
      );

      return Workout.fromAppwrite(response.data, response.$id);
    } catch (e) {
      print('Error fetching workout: $e');
      return null;
    }
  }

  /// Search workouts
  static Future<List<Workout>> searchWorkouts(String query) async {
    try {
      final response = await AppwriteClient.databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _workoutsCollectionId,
        queries: [
          Query.or([
            Query.search('title', query),
            Query.search('description', query),
            Query.search('tags', query),
          ]),
        ],
      );

      return response.documents.map((doc) {
        return Workout.fromAppwrite(doc.data, doc.$id);
      }).toList();
    } catch (e) {
      print('Error searching workouts: $e');
      return [];
    }
  }

  /// Create workout log in Appwrite
  static Future<String?> createWorkoutLog(WorkoutLog log) async {
    try {
      final response = await AppwriteClient.databases.createDocument(
        databaseId: _databaseId,
        collectionId: 'workout_logs',
        documentId: log.id,
        data: log.toAppwrite(),
        permissions: [
          Permission.read(Role.user(log.odId)),
          Permission.write(Role.user(log.odId)),
        ],
      );
      return response.$id;
    } catch (e) {
      print('Error creating workout log: $e');
      return null;
    }
  }

  /// Get workout logs for user
  static Future<List<WorkoutLog>> getWorkoutLogs(String odId) async {
    try {
      final response = await AppwriteClient.databases.listDocuments(
        databaseId: _databaseId,
        collectionId: 'workout_logs',
        queries: [
          Query.equal('user_id', odId),
          Query.orderDesc('start_time'),
          Query.limit(100),
        ],
      );

      return response.documents.map((doc) {
        return WorkoutLog(
          id: doc.$id,
          odId: doc.data['user_id'] as String,
          workoutId: doc.data['workout_id'] as String,
          workoutTitle: doc.data['workout_title'] as String,
          startTime: DateTime.parse(doc.data['start_time'] as String),
          endTime: doc.data['end_time'] != null
              ? DateTime.parse(doc.data['end_time'] as String)
              : null,
          durationMinutes: doc.data['duration_minutes'] as int? ?? 0,
          caloriesBurned: doc.data['calories_burned'] as int? ?? 0,
          notes: doc.data['notes'] as String?,
          syncStatus: 'synced',
          category: doc.data['category'] as String?,
          difficulty: doc.data['difficulty'] as String? ?? 'beginner',
          distanceKm: doc.data['distance_km'] as double?,
        );
      }).toList();
    } catch (e) {
      print('Error fetching workout logs: $e');
      return [];
    }
  }

  /// Create personal record in Appwrite
  static Future<String?> createPersonalRecord(PersonalRecord record) async {
    try {
      final response = await AppwriteClient.databases.createDocument(
        databaseId: _databaseId,
        collectionId: 'personal_records',
        documentId: record.id,
        data: record.toAppwrite(),
        permissions: [
          Permission.read(Role.user(record.odId)),
          Permission.write(Role.user(record.odId)),
        ],
      );
      return response.$id;
    } catch (e) {
      print('Error creating personal record: $e');
      return null;
    }
  }

  /// Get personal records for user
  static Future<List<PersonalRecord>> getPersonalRecords(String odId) async {
    try {
      final response = await AppwriteClient.databases.listDocuments(
        databaseId: _databaseId,
        collectionId: 'personal_records',
        queries: [Query.equal('user_id', odId), Query.orderDesc('achieved_at')],
      );

      return response.documents.map((doc) {
        return PersonalRecord(
          id: doc.$id,
          odId: doc.data['user_id'] as String,
          exerciseName: doc.data['exercise_name'] as String,
          maxWeight: (doc.data['max_weight'] as num).toDouble(),
          maxReps: doc.data['max_reps'] as int,
          maxDuration: doc.data['max_duration'] as int,
          achievedAt: DateTime.parse(doc.data['achieved_at'] as String),
          workoutLogId: doc.data['workout_log_id'] as String?,
          recordType: doc.data['record_type'] as String,
        );
      }).toList();
    } catch (e) {
      print('Error fetching personal records: $e');
      return [];
    }
  }

  /// Get weekly workout stats
  static Future<Map<String, dynamic>> getWeeklyStats(String odId) async {
    try {
      final weekAgo = DateTime.now().subtract(const Duration(days: 7));

      final response = await AppwriteClient.databases.listDocuments(
        databaseId: _databaseId,
        collectionId: 'workout_logs',
        queries: [
          Query.equal('user_id', odId),
          Query.greaterThan('start_time', weekAgo.toIso8601String()),
        ],
      );

      int totalDuration = 0;
      int totalCalories = 0;
      int workoutCount = response.documents.length;

      for (final doc in response.documents) {
        totalDuration += doc.data['duration_minutes'] as int? ?? 0;
        totalCalories += doc.data['calories_burned'] as int? ?? 0;
      }

      return {
        'total_duration': totalDuration,
        'total_calories': totalCalories,
        'workout_count': workoutCount,
      };
    } catch (e) {
      print('Error fetching weekly stats: $e');
      return {'total_duration': 0, 'total_calories': 0, 'workout_count': 0};
    }
  }
}
