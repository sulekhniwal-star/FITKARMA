// lib/features/karma/data/karma_aw_service.dart
import 'package:appwrite/appwrite.dart';
import '../../../core/network/appwrite_client.dart';
import '../../../core/constants/app_config.dart';
import '../domain/karma_model.dart';

/// Service for syncing karma/XP to Appwrite
/// Server is the source of truth for balances
class KarmaAwService {
  static String get _databaseId => AppConfig.appwriteDatabaseId;
  static const String _karmaCollectionId = 'karma_transactions';

  /// Create a karma transaction in Appwrite
  static Future<String?> createTransaction(KarmaTransaction transaction) async {
    try {
      final response = await AppwriteClient.databases.createDocument(
        databaseId: _databaseId,
        collectionId: _karmaCollectionId,
        documentId: transaction.id,
        data: transaction.toAppwrite(),
        permissions: [
          Permission.read(Role.user(transaction.userId)),
          Permission.write(Role.user(transaction.userId)),
        ],
      );
      return response.$id;
    } catch (e) {
      print('Error creating karma transaction: $e');
      return null;
    }
  }

  /// Get user's karma transactions from Appwrite
  static Future<List<KarmaTransaction>> getTransactions(String odId) async {
    try {
      final response = await AppwriteClient.databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _karmaCollectionId,
        queries: [
          Query.equal('user_id', odId),
          Query.orderDesc('timestamp'),
          Query.limit(100),
        ],
      );

      return response.documents.map((doc) {
        return KarmaTransaction(
          id: doc.$id,
          userId: doc.data['user_id'] as String,
          amount: doc.data['amount'] as int,
          action: doc.data['action'] as String,
          description: doc.data['description'] as String,
          timestamp: DateTime.parse(doc.data['timestamp'] as String),
          syncStatus: 'synced',
          multiplier: (doc.data['multiplier'] as num).toDouble(),
        );
      }).toList();
    } catch (e) {
      print('Error fetching karma transactions: $e');
      return [];
    }
  }

  /// Get user's total XP from Appwrite (server-side balance)
  static Future<int> getTotalXP(String odId) async {
    try {
      // Calculate from transactions
      final transactions = await getTransactions(odId);
      int total = 0;
      for (final t in transactions) {
        total += t.finalAmount;
      }
      return total;
    } catch (e) {
      print('Error fetching total XP: $e');
      return 0;
    }
  }

  /// Get weekly leaderboard
  static Future<List<Map<String, dynamic>>> getWeeklyLeaderboard() async {
    try {
      // Get transactions from the last 7 days
      final weekAgo = DateTime.now().subtract(const Duration(days: 7));

      final response = await AppwriteClient.databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _karmaCollectionId,
        queries: [
          Query.greaterThan('timestamp', weekAgo.toIso8601String()),
          Query.limit(1000),
        ],
      );

      // Aggregate XP by user
      final xpByUser = <String, int>{};
      for (final doc in response.documents) {
        final userId = doc.data['user_id'] as String;
        final amount = doc.data['amount'] as int;
        final multiplier = (doc.data['multiplier'] as num).toDouble();
        final finalAmount = (amount * multiplier).round();

        xpByUser[userId] = (xpByUser[userId] ?? 0) + finalAmount;
      }

      // Convert to list and sort
      final leaderboard =
          xpByUser.entries
              .map((e) => {'user_id': e.key, 'weekly_xp': e.value})
              .toList()
            ..sort(
              (a, b) =>
                  (b['weekly_xp'] as int).compareTo(a['weekly_xp'] as int),
            );

      return leaderboard;
    } catch (e) {
      print('Error fetching leaderboard: $e');
      return [];
    }
  }

  /// Subscribe to karma transactions realtime
  static Stream<RealtimeMessage> subscribeToTransactions(String odId) {
    // Subscribe to database updates
    return AppwriteClient.realtime.subscribe([
      'databases.$_databaseId.collections.$_karmaCollectionId.documents',
    ]).stream;
  }

  /// Sync pending local transactions to Appwrite
  static Future<void> syncPendingTransactions(
    List<KarmaTransaction> transactions,
  ) async {
    for (final transaction in transactions) {
      await createTransaction(transaction);
    }
  }
}
