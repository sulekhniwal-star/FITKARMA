import 'package:appwrite/models.dart' as models;

class StepLog {
  final String id;
  final String userId;
  final int steps;
  final DateTime date;
  final String syncStatus;

  StepLog({
    required this.id,
    required this.userId,
    required this.steps,
    required this.date,
    this.syncStatus = 'synced',
  });

  factory StepLog.fromAppwrite(models.Document doc) {
    return StepLog(
      id: doc.$id,
      userId: doc.data['user_id'] ?? '',
      steps: doc.data['steps'] ?? 0,
      date: DateTime.parse(doc.data['date'] ?? doc.$createdAt),
      syncStatus: 'synced',
    );
  }

  Map<String, dynamic> toAppwrite() {
    return {
      'user_id': userId,
      'steps': steps,
      'date': date.toIso8601String(),
    };
  }
}
