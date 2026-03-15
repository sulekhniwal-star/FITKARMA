// lib/features/auth/providers/auth_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_aw_service.dart';

/// Provider for the AuthAwService singleton
final authServiceProvider = Provider<AuthAwService>((ref) {
  return AuthAwService();
});

/// Provider for checking if user is authenticated
/// This is used to determine initial navigation route
final authStateProvider = FutureProvider<bool>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.isAuthenticated();
});

/// Provider for the current user
/// Returns null if not authenticated
final currentUserProvider = FutureProvider.autoDispose((ref) async {
  final authService = ref.watch(authServiceProvider);
  try {
    return await authService.getCurrentUser();
  } catch (e) {
    return null;
  }
});
