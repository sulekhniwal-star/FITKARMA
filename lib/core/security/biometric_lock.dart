import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';

part 'biometric_lock.g.dart';

/// BiometricLock — Wrapper for local_auth functionality.
class BiometricLock {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> authenticate({required String reason}) async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) return true; // Fail safe if no hardware

      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}

@riverpod
class BiometricAuthState extends _$BiometricAuthState {
  @override
  Set<String> build() => {};

  void markAuthenticated(String screenId) {
    state = {...state, screenId};
  }
}

/// SensitiveScreenGuard — A widget that gates content behind biometric auth.
class SensitiveScreenGuard extends ConsumerStatefulWidget {
  final String screenId;
  final Widget child;

  const SensitiveScreenGuard({
    super.key,
    required this.screenId,
    required this.child,
  });

  @override
  ConsumerState<SensitiveScreenGuard> createState() => _SensitiveScreenGuardState();
}

class _SensitiveScreenGuardState extends ConsumerState<SensitiveScreenGuard> {
  bool _isLocked = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final alreadyAuthenticated = ref.read(biometricAuthStateProvider).contains(widget.screenId);
    
    if (alreadyAuthenticated) {
      if (mounted) setState(() => _isLocked = false);
      return;
    }

    final success = await BiometricLock.authenticate(
      reason: 'Please authenticate to access your sensitive health data.',
    );

    if (success) {
      ref.read(biometricAuthStateProvider.notifier).markAuthenticated(widget.screenId);
      if (mounted) setState(() => _isLocked = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLocked) return widget.child;

    return AppScaffold.patternC(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_person_rounded,
              size: 64,
              color: AppColorsDark.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Locked Area',
              style: AppTypography.h1(),
            ),
            const SizedBox(height: 12),
            Text(
              'Biometric authentication required',
              style: AppTypography.bodyMd(color: AppColorsDark.textSecondary),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _checkAuth,
              child: const Text('Unlock with Biometrics'),
            ),
          ],
        ),
      ),
    );
  }
}
