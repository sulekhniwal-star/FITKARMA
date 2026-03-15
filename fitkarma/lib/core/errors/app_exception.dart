// lib/core/errors/app_exception.dart

/// Base exception class for all app-specific errors.
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Network-related exceptions.
class NetworkException extends AppException {
  final bool isOffline;

  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
    this.isOffline = false,
  });

  factory NetworkException.noConnection() => const NetworkException(
    message: 'No internet connection. Please check your network settings.',
    code: 'NO_CONNECTION',
    isOffline: true,
  );

  factory NetworkException.timeout() => const NetworkException(
    message: 'Request timed out. Please try again.',
    code: 'TIMEOUT',
  );

  factory NetworkException.serverError([String? details]) => NetworkException(
    message: details ?? 'Server error. Please try again later.',
    code: 'SERVER_ERROR',
  );
}

/// Storage-related exceptions (Hive, local storage).
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory StorageException.readError(String item) => StorageException(
    message: 'Failed to read $item from storage.',
    code: 'READ_ERROR',
  );

  factory StorageException.writeError(String item) =>
      StorageException(message: 'Failed to save $item.', code: 'WRITE_ERROR');

  factory StorageException.deleteError(String item) => StorageException(
    message: 'Failed to delete $item.',
    code: 'DELETE_ERROR',
  );

  factory StorageException.boxNotOpen(String boxName) => StorageException(
    message: 'Storage box "$boxName" is not open.',
    code: 'BOX_NOT_OPEN',
  );
}

/// Authentication and authorization exceptions.
class AuthException extends AppException {
  final bool isSessionExpired;

  const AuthException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
    this.isSessionExpired = false,
  });

  factory AuthException.invalidCredentials() => const AuthException(
    message: 'Invalid email or password.',
    code: 'INVALID_CREDENTIALS',
  );

  factory AuthException.sessionExpired() => const AuthException(
    message: 'Your session has expired. Please log in again.',
    code: 'SESSION_EXPIRED',
    isSessionExpired: true,
  );

  factory AuthException.unauthorized() => const AuthException(
    message: 'You are not authorized to perform this action.',
    code: 'UNAUTHORIZED',
  );

  factory AuthException.userNotFound() =>
      const AuthException(message: 'User not found.', code: 'USER_NOT_FOUND');

  factory AuthException.emailNotVerified() => const AuthException(
    message: 'Please verify your email address.',
    code: 'EMAIL_NOT_VERIFIED',
  );
}

/// Encryption/decryption exceptions.
class EncryptionException extends AppException {
  const EncryptionException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory EncryptionException.keyNotSet() => const EncryptionException(
    message: 'Encryption key not set. Please log in first.',
    code: 'KEY_NOT_SET',
  );

  factory EncryptionException.decryptionFailed() => const EncryptionException(
    message: 'Failed to decrypt data. The data may be corrupted.',
    code: 'DECRYPTION_FAILED',
  );

  factory EncryptionException.encryptionFailed() => const EncryptionException(
    message: 'Failed to encrypt data.',
    code: 'ENCRYPTION_FAILED',
  );

  factory EncryptionException.invalidKey() => const EncryptionException(
    message: 'Invalid encryption key.',
    code: 'INVALID_KEY',
  );
}

/// Validation exceptions for user input.
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code,
    this.fieldErrors,
    super.originalError,
    super.stackTrace,
  });

  factory ValidationException.required(String field) => ValidationException(
    message: '$field is required.',
    code: 'REQUIRED_FIELD',
    fieldErrors: {field: 'This field is required'},
  );

  factory ValidationException.invalid(String field, String reason) =>
      ValidationException(
        message: '$field is invalid: $reason',
        code: 'INVALID_FIELD',
        fieldErrors: {field: reason},
      );
}

/// Sync-related exceptions.
class SyncException extends AppException {
  final int retryCount;

  const SyncException({
    required super.message,
    super.code,
    this.retryCount = 0,
    super.originalError,
    super.stackTrace,
  });

  factory SyncException.maxRetriesExceeded() => const SyncException(
    message: 'Failed to sync after multiple attempts. Will retry when online.',
    code: 'MAX_RETRIES_EXCEEDED',
  );

  factory SyncException.conflict(String details) =>
      SyncException(message: 'Sync conflict: $details', code: 'SYNC_CONFLICT');
}

/// Appwrite-specific exceptions.
class AppwriteException extends AppException {
  final int? statusCode;

  const AppwriteException({
    required super.message,
    super.code,
    this.statusCode,
    super.originalError,
    super.stackTrace,
  });

  factory AppwriteException.fromError(dynamic error) {
    // Extract useful information from Appwrite error response
    String message = 'An error occurred';
    String? code;
    int? statusCode;

    if (error is Map) {
      message = error['message']?.toString() ?? message;
      code = error['code']?.toString();
      statusCode = error['type'] != null
          ? int.tryParse(error['type'].toString().split(' ').last)
          : null;
    }

    return AppwriteException(
      message: message,
      code: code,
      statusCode: statusCode,
      originalError: error,
    );
  }
}
