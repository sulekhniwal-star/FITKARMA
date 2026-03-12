import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/di/providers.dart';
import '../domain/karma_transaction_model.dart';

class KarmaRepository {
  final Databases _databases;
  final Realtime _realtime;

  KarmaRepository(this._databases, this._realtime);

  Future<void> logTransaction(KarmaTransaction tx) async {
    await _databases.createDocument(
      databaseId: AW.dbId,
      collectionId: AW.karmaTx,
      documentId: ID.unique(),
      data: tx.toAppwrite(),
    );
  }

  Future<List<KarmaTransaction>> getHistory(String userId) async {
    final result = await _databases.listDocuments(
      databaseId: AW.dbId,
      collectionId: AW.karmaTx,
      queries: [
        Query.equal('user_id', userId),
        Query.orderDesc('\$createdAt'),
      ],
    );
    
    return result.documents.map((doc) => KarmaTransaction.fromAppwrite(doc)).toList();
  }

  RealtimeSubscription subscribeToKarma(String userId) {
    return _realtime.subscribe([
      'databases.${AW.dbId}.collections.${AW.karmaTx}.documents',
    ]);
  }
}

final karmaRepositoryProvider = Provider<KarmaRepository>((ref) {
  final databases = ref.watch(appwriteDatabaseProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  return KarmaRepository(databases, realtime);
});
