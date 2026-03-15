// lib/core/errors/error_handler.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'app_exception.dart';

/// Error handler that maps raw exceptions to user-friendly messages.
///
/// Used throughout the app to display appropriate error messages to users.
class ErrorHandler {
  ErrorHandler._();

  /// Maps an exception to a user-friendly message.
  static String getMessage(dynamic error) {
    if (error == null) {
      return 'An unexpected error occurred.';
    }

    // Handle our custom exceptions
    if (error is AppException) {
      return error.message;
    }

    // Handle common Flutter/Dart exceptions
    if (error is SocketException) {
      return 'No internet connection. Please check your network.';
    }

    if (error is TimeoutException) {
      return 'Request timed out. Please try again.';
    }

    if (error is FormatException) {
      return 'Invalid data format. Please try again.';
    }

    // Handle unknown exceptions
    return 'An unexpected error occurred. Please try again.';
  }

  /// Gets a user-friendly title for the error.
  static String getTitle(dynamic error) {
    if (error == null) {
      return 'Error';
    }

    if (error is NetworkException) {
      return 'Connection Error';
    }

    if (error is StorageException) {
      return 'Storage Error';
    }

    if (error is AuthException) {
      return 'Authentication Error';
    }

    if (error is EncryptionException) {
      return 'Security Error';
    }

    if (error is ValidationException) {
      return 'Validation Error';
    }

    if (error is SyncException) {
      return 'Sync Error';
    }

    return 'Error';
  }

  /// Determines if the error can be retried.
  static bool canRetry(dynamic error) {
    if (error is NetworkException) {
      return !error.isOffline;
    }

    if (error is StorageException) {
      return true;
    }

    if (error is SyncException) {
      return true;
    }

    if (error is TimeoutException) {
      return true;
    }

    return false;
  }

  /// Gets the appropriate icon for the error type.
  static IconData getIcon(dynamic error) {
    if (error == null) {
      return Icons.error_outline;
    }

    if (error is NetworkException) {
      return error.isOffline ? Icons.wifi_off : Icons.wifi;
    }

    if (error is StorageException) {
      return Icons.storage;
    }

    if (error is AuthException) {
      return Icons.lock_outline;
    }

    if (error is EncryptionException) {
      return Icons.security;
    }

    if (error is ValidationException) {
      return Icons.warning_amber;
    }

    if (error is SyncException) {
      return Icons.sync_problem;
    }

    return Icons.error_outline;
  }

  /// Gets the appropriate color for the error type.
  static Color getColor(dynamic error) {
    if (error == null) {
      return Colors.red;
    }

    if (error is NetworkException) {
      return error.isOffline ? Colors.orange : Colors.red;
    }

    if (error is StorageException) {
      return Colors.orange;
    }

    if (error is AuthException) {
      return Colors.blue;
    }

    if (error is EncryptionException) {
      return Colors.red;
    }

    if (error is ValidationException) {
      return Colors.amber;
    }

    if (error is SyncException) {
      return Colors.orange;
    }

    return Colors.red;
  }

  /// Shows an error snackbar.
  static void showSnackBar(BuildContext context, dynamic error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(getIcon(error), color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                getMessage(error),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: getColor(error),
        behavior: SnackBarBehavior.floating,
        action: canRetry(error)
            ? SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () {
                  // Retry action can be customized
                },
              )
            : null,
      ),
    );
  }

  /// Shows an error dialog.
  static Future<void> showErrorDialog(
    BuildContext context, {
    required dynamic error,
    String? title,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(getIcon(error), color: getColor(error)),
            const SizedBox(width: 8),
            Text(title ?? getTitle(error)),
          ],
        ),
        content: Text(getMessage(error)),
        actions: [
          if (onDismiss != null)
            TextButton(onPressed: onDismiss, child: const Text('Dismiss')),
          if (onRetry != null && canRetry(error))
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }

  /// Handles an error and shows appropriate UI feedback.
  static Future<void> handle(
    BuildContext context,
    dynamic error, {
    bool showDialog = false,
    bool showSnackBar = true,
    String? title,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) async {
    // Log the error for debugging
    debugPrint('Error handled: $error');

    if (showDialog) {
      await showErrorDialog(
        context,
        error: error,
        title: title,
        onRetry: onRetry,
        onDismiss: onDismiss,
      );
    } else if (showSnackBar) {
      ErrorHandler.showSnackBar(context, error);
    }
  }
}
