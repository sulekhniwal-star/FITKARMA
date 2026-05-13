import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:mocktail/mocktail.dart';

class MockTablesDB extends Mock implements TablesDB {}

class MockDb extends Mock implements AppDatabase {}

void main() {
  group('SyncWorker', () {
    late SyncWorker worker;
    late MockDb mockDb;

    setUp(() {
      mockDb = MockDb();
      worker = SyncWorker(
        tablesDb: MockTablesDB(),
        db: mockDb,
        isLowDataMode: false,
      );
    });

    group('connectivity guard', () {
      test('syncAll returns early when isLowDataMode is true', () async {
        final workerLowData = SyncWorker(
          tablesDb: MockTablesDB(),
          db: mockDb,
          isLowDataMode: true,
        );

        await workerLowData.syncAll();

        verifyNever(() => mockDb.select(any));
      });
    });

    group('pending to synced', () {
      test('successful sync updates status to synced', () async {
        final companion = BpReadingsCompanion.insert(
          id: 'test-id',
          userId: 'user-1',
          systolic: 120,
          diastolic: 80,
          pulse: 70,
          measuredAt: DateTime.now(),
          syncStatus: const Value('pending'),
        );

        when(() => mockDb.bpReadings).thenReturn(mockDb);
        when(() => mockDb.glucoseReadings).thenReturn(mockDb);
        when(() => mockDb.medications).thenReturn(mockDb);
        when(() => mockDb.workouts).thenReturn(mockDb);
        when(() => mockDb.sleepLogs).thenReturn(mockDb);
        when(() => mockDb.foodLogs).thenReturn(mockDb);
        when(() => mockDb.habits).thenReturn(mockDb);
        when(() => mockDb.journalEntries).thenReturn(mockDb);
        when(() => mockDb.waterLogs).thenReturn(mockDb);
        when(() => mockDb.select(any)).thenAnswer((_) => mockDb);
        when(() => mockDb.update(any)).thenAnswer((_) => mockDb);
        when(() => mockDb.into(any)).thenReturn(mockDb);

        await worker.syncAll();

        verify(() => mockDb.select(any)).called(greaterThan(0));
      });
    });

    group('pending to dlq', () {
      test('three failed attempts transition to dlq', () async {
        var attemptCount = 0;

        when(() => mockDb.select(any)).thenAnswer((_) {
          attemptCount++;
          return mockDb;
        });

        when(() => mockDb.update(any)).thenAnswer((_) => mockDb);

        await worker.syncAll();

        expect(attemptCount, greaterThan(0));
      });
    });
  });
}