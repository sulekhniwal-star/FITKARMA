import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:appwrite/appwrite.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/core/database/app_database.dart';

class MockTablesDB extends Mock implements TablesDB {}
class MockDb extends Mock implements AppDatabase {}

void main() {
  group('SyncWorker', () {
    late MockDb mockDb;

    setUp(() {
      mockDb = MockDb();
    });

    test('syncAll returns early when isLowDataMode is true', () async {
      final workerLowData = SyncWorker(
        tablesDb: MockTablesDB(),
        db: mockDb,
        isLowDataMode: true,
      );

      await workerLowData.syncAll();

      verifyZeroInteractions(mockDb);
    });

    test('SyncWorker initializes cleanly with default parameters', () {
      final worker = SyncWorker(
        tablesDb: MockTablesDB(),
        db: mockDb,
      );

      expect(worker.isLowDataMode, isFalse);
      expect(worker.db, equals(mockDb));
    });
  });
}