// lib/core/constants/app_config.dart
class AppConfig {
  static String get appwriteEndpoint => const String.fromEnvironment(
    'APPWRITE_ENDPOINT',
    defaultValue: 'https://cloud.appwrite.io/v1',
  );

  static String get appwriteProjectId =>
      const String.fromEnvironment('APPWRITE_PROJECT_ID');

  static String get appwriteDatabaseId =>
      const String.fromEnvironment('APPWRITE_DATABASE_ID');

  static String get razorpayKeyId =>
      const String.fromEnvironment('RAZORPAY_KEY_ID');

  // Public ID only; secret stays server-side in Appwrite Functions
  static String get fitbitClientId =>
      const String.fromEnvironment('FITBIT_CLIENT_ID');
}

// Build command:
// flutter run --dart-define-from-file=.env
