import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../core/providers/core_providers.dart';
import '../onboarding/onboarding_providers.dart';

class SubscriptionService {
  final Ref _ref;
  bool _isInitialized = false;

  SubscriptionService(this._ref);

  /// Initialize RevenueCat SDK configuring explicit API keys using environment injection
  Future<void> init() async {
    if (_isInitialized) return;

    const apiKey = String.fromEnvironment('REVENUECAT_API_KEY', defaultValue: '');
    if (apiKey.isEmpty) {
      debugPrint('REVENUECAT_API_KEY not provided via --dart-define. RevenueCat checks will operate in simulated sandbox mode.');
      return;
    }

    try {
      await Purchases.setLogLevel(LogLevel.debug);
      await Purchases.configure(PurchasesConfiguration(apiKey));
      
      final user = _ref.read(authProvider).value;
      if (user != null) {
        await Purchases.logIn(user.$id);
      }
      
      _isInitialized = true;
    } catch (e) {
      debugPrint('RevenueCat initialization exception: $e');
    }
  }

  /// Verify active Entitlement validation mapped to standard RevenueCat key 'pro'
  Future<bool> isPro() async {
    try {
      await init();
      final customerInfo = await Purchases.getCustomerInfo();
      final entitlement = customerInfo.entitlements.active['pro'];
      return entitlement != null && entitlement.isActive;
    } catch (e) {
      debugPrint('RevenueCat entitlement check error: $e');
      return false;
    }
  }

  /// Trigger product acquisition fetching active Offerings array to process monthly subscription package
  Future<bool> purchasePro() async {
    try {
      await init();
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      
      if (current == null || current.monthly == null) {
        debugPrint('No monthly package configured in active RevenueCat dashboard offering.');
        return false;
      }

      final customerInfo = await Purchases.purchasePackage(current.monthly!);
      final entitlement = customerInfo.entitlements.active['pro'];
      return entitlement != null && entitlement.isActive;
    } catch (e) {
      final str = e.toString();
      if (str.contains('purchaseCancelled') || str.contains('1')) {
        // Handle cancelled transaction silently per UX requirements
        debugPrint('User cancelled subscription checkout flow cleanly.');
        return false;
      }
      debugPrint('Subscription checkout exception: $e');
      return false;
    }
  }

  /// Restore historical App Store / Play Store purchases synchronized to current subscriber profile
  Future<bool> restorePurchases() async {
    try {
      await init();
      final customerInfo = await Purchases.restorePurchases();
      final entitlement = customerInfo.entitlements.active['pro'];
      return entitlement != null && entitlement.isActive;
    } catch (e) {
      debugPrint('Purchase restoration failure: $e');
      return false;
    }
  }
}

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  return SubscriptionService(ref);
});

class SubscriptionNotifier extends Notifier<AsyncValue<bool>> {
  @override
  AsyncValue<bool> build() {
    Future.microtask(() => checkAccess());
    return const AsyncValue.loading();
  }

  Future<void> checkAccess() async {
    state = const AsyncValue.loading();
    final service = ref.read(subscriptionServiceProvider);
    final isProUser = await service.isPro();
    state = AsyncValue.data(isProUser);
  }

  Future<bool> purchase() async {
    state = const AsyncValue.loading();
    final service = ref.read(subscriptionServiceProvider);
    final success = await service.purchasePro();
    
    // Invalidate primary global access wrapper provider to trigger interface reflows
    ref.invalidate(isProProvider);
    state = AsyncValue.data(success);
    return success;
  }

  Future<bool> restore() async {
    state = const AsyncValue.loading();
    final service = ref.read(subscriptionServiceProvider);
    final success = await service.restorePurchases();
    
    ref.invalidate(isProProvider);
    state = AsyncValue.data(success);
    return success;
  }
}

final subscriptionNotifierProvider = NotifierProvider<SubscriptionNotifier, AsyncValue<bool>>(SubscriptionNotifier.new);
