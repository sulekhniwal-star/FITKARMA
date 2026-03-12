import 'package:appwrite/models.dart' as models;

class KarmaTransaction {
  final String id;
  final String userId;
  final String action; // food_log, workout_completion, etc.
  final int xpEarned;
  final DateTime createdAt;

  KarmaTransaction({
    required this.id,
    required this.userId,
    required this.action,
    required this.xpEarned,
    required this.createdAt,
  });

  factory KarmaTransaction.fromAppwrite(models.Document doc) {
    return KarmaTransaction(
      id: doc.$id,
      userId: doc.data['user_id'] ?? '',
      action: doc.data['action'] ?? '',
      xpEarned: doc.data['xp_earned'] ?? 0,
      createdAt: DateTime.parse(doc.$createdAt),
    );
  }

  Map<String, dynamic> toAppwrite() {
    return {
      'user_id': userId,
      'action': action,
      'xp_earned': xpEarned,
    };
  }
}
