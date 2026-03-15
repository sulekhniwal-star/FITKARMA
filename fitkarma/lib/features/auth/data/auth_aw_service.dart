// lib/features/auth/data/auth_aw_service.dart
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/network/appwrite_client.dart';
import '../../../core/constants/app_config.dart';

/// Custom OAuthProvider enum that matches Appwrite's expected format
/// This is needed because the SDK's OAuthProvider enum is not directly accessible
enum AuthOAuthProvider {
  google('google'),
  apple('apple');

  final String value;
  const AuthOAuthProvider(this.value);
}

/// Appwrite Authentication Service
/// Handles email/password authentication, OAuth2 (Google, Apple), and session management
class AuthAwService {
  // Use the Account from AppwriteClient which is already configured
  Account get _account => AppwriteClient.account;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Storage keys
  static const String _jwtKey = 'appwrite_jwt';
  static const String _sessionKey = 'appwrite_session_id';

  // ============================================
  // Email/Password Authentication
  // ============================================

  /// Login with email and password
  /// Returns the session and stores the JWT securely
  Future<models.Session> login(String email, String password) async {
    final session = await _account.createEmailPasswordSession(
      email: email,
      password: password,
    );

    // Store JWT and session ID securely
    await _storeSession(session);
    return session;
  }

  /// Register a new user with email and password
  /// After registration, automatically creates a session
  Future<models.User> register(
    String name,
    String email,
    String password,
  ) async {
    final user = await _account.create(
      userId: ID.unique(),
      name: name,
      email: email,
      password: password,
    );

    // Auto-login after registration
    final session = await login(email, password);
    debugPrint('User registered and logged in: ${user.email}');
    return user;
  }

  /// Logout the current user
  /// Clears the stored JWT and session
  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } finally {
      // Always clear stored credentials
      await _clearSession();
    }
  }

  /// Get the currently authenticated user
  /// Throws an exception if no user is logged in
  Future<models.User> getCurrentUser() => _account.get();

  // ============================================
  // OAuth2 Authentication
  // ============================================

  /// Login with Google OAuth2
  /// Initiates the OAuth2 flow for Google sign-in
  ///
  /// Note: This method opens a browser for OAuth flow
  /// After successful authentication, the app will receive a callback
  Future<void> loginWithGoogle() async {
    final projectId = AppConfig.appwriteProjectId;

    // Use dynamic to bypass type checking since OAuthProvider enum
    // is not directly exported from the appwrite package
    await _createOAuth2Session(
      provider: AuthOAuthProvider.google.value,
      success: 'appwrite-callback-$projectId://auth',
      failure: 'appwrite-callback-$projectId://auth/failure',
    );

    // After OAuth success, store the JWT
    await _refreshJwt();
  }

  /// Login with Apple Sign-In (iOS only)
  /// Initiates the OAuth2 flow for Apple sign-in
  /// Note: On Android, this will show a web-based Apple login
  Future<void> loginWithApple() async {
    final projectId = AppConfig.appwriteProjectId;

    await _createOAuth2Session(
      provider: AuthOAuthProvider.apple.value,
      success: 'appwrite-callback-$projectId://auth',
      failure: 'appwrite-callback-$projectId://auth/failure',
    );

    // After OAuth success, store the JWT
    await _refreshJwt();
  }

  /// Helper method to create OAuth2 session
  /// Uses dynamic invocation to work around type issues
  Future<void> _createOAuth2Session({
    required String provider,
    required String success,
    required String failure,
  }) async {
    // Use the Account's createOAuth2Session method
    // We use runtimeType to get the method and invoke it
    try {
      // Try to call using reflection-like approach via dynamic
      final account = _account;
      // The createOAuth2Session method takes named parameters
      await (account as dynamic).createOAuth2Session(
        provider: provider,
        success: success,
        failure: failure,
      );
    } catch (e) {
      debugPrint('OAuth2 session creation error: $e');
      rethrow;
    }
  }

  // ============================================
  // Session Management
  // ============================================

  /// Store session data securely
  Future<void> _storeSession(models.Session session) async {
    // Store the JWT token
    if (session.providerAccessToken.isNotEmpty) {
      await _secureStorage.write(
        key: _jwtKey,
        value: session.providerAccessToken,
      );
    }

    // Store session ID for reference (Appwrite uses $id)
    await _secureStorage.write(key: _sessionKey, value: session.$id);
  }

  /// Clear stored session data
  Future<void> _clearSession() async {
    await _secureStorage.delete(key: _jwtKey);
    await _secureStorage.delete(key: _sessionKey);
  }

  /// Refresh the stored JWT from the current session
  Future<void> _refreshJwt() async {
    try {
      final session = await _account.getSession(sessionId: 'current');
      if (session.providerAccessToken.isNotEmpty) {
        await _secureStorage.write(
          key: _jwtKey,
          value: session.providerAccessToken,
        );
      }
    } catch (e) {
      debugPrint('Failed to refresh JWT: $e');
    }
  }

  /// Check if a valid session exists on app start
  /// Returns true if there's a stored session
  Future<bool> hasStoredSession() async {
    final jwt = await _secureStorage.read(key: _jwtKey);
    return jwt != null && jwt.isNotEmpty;
  }

  /// Try to restore the session on app start
  /// Returns true if session was successfully restored
  Future<bool> restoreSession() async {
    try {
      // Try to get the current session from Appwrite
      final session = await _account.getSession(sessionId: 'current');

      // If we have an active session, refresh the JWT
      await _refreshJwt();
      return true;
    } catch (e) {
      // No valid session exists
      debugPrint('No valid session to restore: $e');
      await _clearSession();
      return false;
    }
  }

  /// Get the stored JWT token
  Future<String?> getStoredJwt() async {
    return await _secureStorage.read(key: _jwtKey);
  }

  /// Check if user is authenticated
  /// Returns true if we have a valid session or can restore one
  Future<bool> isAuthenticated() async {
    // First check if we have stored credentials
    if (!await hasStoredSession()) {
      return false;
    }

    // Try to restore and validate the session
    return await restoreSession();
  }
}
