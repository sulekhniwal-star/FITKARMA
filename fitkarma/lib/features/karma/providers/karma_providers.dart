// lib/features/karma/providers/karma_providers.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/karma_hive_service.dart';
import '../data/karma_aw_service.dart';
import '../domain/karma_model.dart';

/// State for karma/XP
class KarmaState {
  final KarmaBalance? balance;
  final List<KarmaTransaction> transactions;
  final bool isLoading;
  final String? error;

  const KarmaState({
    this.balance,
    this.transactions = const [],
    this.isLoading = false,
    this.error,
  });

  KarmaState copyWith({
    KarmaBalance? balance,
    List<KarmaTransaction>? transactions,
    bool? isLoading,
    String? error,
  }) {
    return KarmaState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier for karma state management
class KarmaNotifier extends StateNotifier<KarmaState> {
  final String odId;
  StreamSubscription? _realtimeSubscription;

  KarmaNotifier(this.odId) : super(const KarmaState());

  /// Initialize karma - load balance and transactions
  Future<void> init() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // Load local balance
      var balance = KarmaHiveService.getBalance(odId);
      
      // If no local balance, try to fetch from server
      if (balance == null) {
        final serverXP = await KarmaAwService.getTotalXP(odId);
        if (serverXP > 0) {
          // Create balance from server
          balance = KarmaBalance(odId: odId, totalXP: serverXP);
        } else {
          // Create new balance
          balance = KarmaBalance(odId: odId);
        }
        await KarmaHiveService.updateBalance(balance);
      }

      // Load transactions
      final transactions = KarmaHiveService.getTransactionHistory(odId);
      
      state = state.copyWith(
        balance: balance,
        transactions: transactions,
        isLoading: false,
      );

      // Subscribe to realtime updates
      _subscribeToRealtime();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Subscribe to Appwrite realtime updates
  void _subscribeToRealtime() {
    try {
      _realtimeSubscription = KarmaAwService.subscribeToTransactions(odId).listen(
        (event) {
          // Refresh when new transactions come in
          _refreshFromServer();
        },
        onError: (e) {
          print('Realtime subscription error: $e');
        },
      );
    } catch (e) {
      print('Error subscribing to realtime: $e');
    }
  }

  /// Refresh from server
  Future<void> _refreshFromServer() async {
    try {
      final transactions = await KarmaAwService.getTransactions(odId);
      final totalXP = await KarmaAwService.getTotalXP(odId);
      
      if (state.balance != null) {
        final updated = state.balance!.copyWith(totalXP: totalXP);
        state = state.copyWith(
          balance: updated,
          transactions: transactions,
        );
      }
    } catch (e) {
      print('Error refreshing from server: $e');
    }
  }

  /// Add XP to user's balance
  Future<void> addXP({
    required int amount,
    required String action,
    required String description,
    double multiplier = 1.0,
  }) async {
    try {
      // Add XP locally (instant feedback)
      final balance = await KarmaHiveService.addXP(
        odId: odId,
        amount: amount,
        action: action,
        description: description,
        multiplier: multiplier,
      );

      // Update state
      final transactions = KarmaHiveService.getTransactionHistory(odId);
      state = state.copyWith(
        balance: balance,
        transactions: transactions,
      );

      // Sync to server in background
      _syncToServer();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Sync pending transactions to server
  Future<void> _syncToServer() async {
    try {
      final pending = KarmaHiveService.getPendingSync();
      if (pending.isNotEmpty) {
        await KarmaAwService.syncPendingTransactions(pending);
        
        // Mark as synced
        await KarmaHiveService.markAsSynced(pending.map((t) => t.id).toList());
      }
    } catch (e) {
      print('Error syncing to server: $e');
    }
  }

  /// Refresh state
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _refreshFromServer();
      final balance = KarmaHiveService.getBalance(odId);
      final transactions = KarmaHiveService.getTransactionHistory(odId);
      
      state = state.copyWith(
        balance: balance,
        transactions: transactions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  @override
  void dispose() {
    _realtimeSubscription?.cancel();
    super.dispose();
  }
}

/// Provider for karma state
final karmaProvider = StateNotifierProvider<KarmaNotifier, KarmaState>((ref) {
  // Get user ID from auth - default to 'default_user' if not available
  const odId = 'default_user';
  return KarmaNotifier(odId);
});

/// Provider for current balance
final karmaBalanceProvider = Provider<KarmaBalance?>((ref) {
  return ref.watch(karmaProvider).balance;
});

/// Provider for transaction history
final karmaTransactionsProvider = Provider<List<KarmaTransaction>>((ref) {
  return ref.watch(karmaProvider).transactions;
});

/// Provider for streak multiplier display
final streakMultiplierProvider = Provider<double>((ref) {
  final balance = ref.watch(karmaBalanceProvider);
  return balance?.streakMultiplier ?? 1.0;
});
