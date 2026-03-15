// lib/features/auth/providers/onboarding_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/appwrite_client.dart';
import '../../../core/constants/app_config.dart';
import '../models/user_profile.dart';

/// Onboarding step enum
enum OnboardingStep {
  name,
  genderDob,
  heightWeight,
  fitnessGoal,
  activityLevel,
  chronicConditions,
  doshaQuiz,
  language,
  healthPermissions,
  wearable,
  completed;

  int get stepIndex {
    switch (this) {
      case OnboardingStep.name:
        return 0;
      case OnboardingStep.genderDob:
        return 1;
      case OnboardingStep.heightWeight:
        return 2;
      case OnboardingStep.fitnessGoal:
        return 3;
      case OnboardingStep.activityLevel:
        return 4;
      case OnboardingStep.chronicConditions:
        return 5;
      case OnboardingStep.doshaQuiz:
        return 6;
      case OnboardingStep.language:
        return 7;
      case OnboardingStep.healthPermissions:
        return 8;
      case OnboardingStep.wearable:
        return 9;
      case OnboardingStep.completed:
        return 10;
    }
  }

  static OnboardingStep fromIndex(int index) {
    switch (index) {
      case 0:
        return OnboardingStep.name;
      case 1:
        return OnboardingStep.genderDob;
      case 2:
        return OnboardingStep.heightWeight;
      case 3:
        return OnboardingStep.fitnessGoal;
      case 4:
        return OnboardingStep.activityLevel;
      case 5:
        return OnboardingStep.chronicConditions;
      case 6:
        return OnboardingStep.doshaQuiz;
      case 7:
        return OnboardingStep.language;
      case 8:
        return OnboardingStep.healthPermissions;
      case 9:
        return OnboardingStep.wearable;
      default:
        return OnboardingStep.completed;
    }
  }
}

/// Onboarding state
class OnboardingState {
  final OnboardingStep currentStep;
  final UserProfile profile;
  final List<int> doshaQuizAnswers;
  final bool isLoading;
  final String? error;

  OnboardingState({
    this.currentStep = OnboardingStep.name,
    UserProfile? profile,
    this.doshaQuizAnswers = const [],
    this.isLoading = false,
    this.error,
  }) : profile = profile ?? UserProfile();

  OnboardingState copyWith({
    OnboardingStep? currentStep,
    UserProfile? profile,
    List<int>? doshaQuizAnswers,
    bool? isLoading,
    String? error,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      profile: profile ?? this.profile,
      doshaQuizAnswers: doshaQuizAnswers ?? this.doshaQuizAnswers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Onboarding notifier
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(OnboardingState());

  /// Update profile field
  void updateProfile({
    String? name,
    String? gender,
    DateTime? dateOfBirth,
    double? heightCm,
    double? weightKg,
    String? fitnessGoal,
    String? activityLevel,
    List<String>? chronicConditions,
    DoshaProfile? doshaProfile,
    String? language,
    List<String>? healthPermissions,
    String? wearableDevice,
  }) {
    state = state.copyWith(
      profile: state.profile.copyWith(
        name: name,
        gender: gender,
        dateOfBirth: dateOfBirth,
        heightCm: heightCm,
        weightKg: weightKg,
        fitnessGoal: fitnessGoal,
        activityLevel: activityLevel,
        chronicConditions: chronicConditions,
        doshaProfile: doshaProfile,
        language: language,
        healthPermissions: healthPermissions,
        wearableDevice: wearableDevice,
      ),
    );
  }

  /// Update dosha quiz answer
  void updateDoshaAnswer(int questionIndex, int answer) {
    final newAnswers = List<int>.from(state.doshaQuizAnswers);
    if (questionIndex < newAnswers.length) {
      newAnswers[questionIndex] = answer;
    } else {
      // Pad with zeros if needed
      while (newAnswers.length < questionIndex) {
        newAnswers.add(0);
      }
      newAnswers.add(answer);
    }
    state = state.copyWith(doshaQuizAnswers: newAnswers);
  }

  /// Go to next step
  void nextStep() {
    final nextIndex = state.currentStep.stepIndex + 1;
    if (nextIndex <= OnboardingStep.completed.stepIndex) {
      state = state.copyWith(
        currentStep: OnboardingStep.fromIndex(nextIndex),
        error: null,
      );
    }
  }

  /// Go to previous step
  void previousStep() {
    final prevIndex = state.currentStep.stepIndex - 1;
    if (prevIndex >= 0) {
      state = state.copyWith(
        currentStep: OnboardingStep.fromIndex(prevIndex),
        error: null,
      );
    }
  }

  /// Go to specific step
  void goToStep(OnboardingStep step) {
    state = state.copyWith(currentStep: step, error: null);
  }

  /// Complete onboarding and save profile
  Future<bool> completeOnboarding() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Calculate dosha profile from quiz answers
      final doshaProfile = DoshaProfile.calculateFromAnswers(state.doshaQuizAnswers);
      
      // Update profile with dosha and mark as completed
      final completedProfile = state.profile.copyWith(
        doshaProfile: doshaProfile,
        onboardingCompleted: true,
        xp: 50, // Award +50 XP
      );
      
      // Set createdAt
      completedProfile.createdAt = DateTime.now();

      // Save to local storage (Hive)
      await _saveToHive(completedProfile);

      // Save to Appwrite
      await _saveToAppwrite(completedProfile);

      state = state.copyWith(
        profile: completedProfile,
        currentStep: OnboardingStep.completed,
        isLoading: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to save profile: $e',
      );
      return false;
    }
  }

  /// Save to Hive
  Future<void> _saveToHive(UserProfile profile) async {
    // Using SharedPreferences or a simple JSON file would work
    // For now, we'll skip this as Hive requires initialization
    // In production, use HiveService to save
  }

  /// Save to Appwrite users collection
  Future<void> _saveToAppwrite(UserProfile profile) async {
    try {
      final databaseId = AppConfig.appwriteDatabaseId;
      const usersCollection = 'users';
      
      // Get current user ID from the account
      final account = AppwriteClient.account;
      final user = await account.get();
      
      // Create or update user document
      final databases = AppwriteClient.databases;
      
      // Check if document exists
      try {
        await databases.getDocument(
          databaseId: databaseId,
          collectionId: usersCollection,
          documentId: user.$id,
        );
        
        // Update existing document
        await databases.updateDocument(
          databaseId: databaseId,
          collectionId: usersCollection,
          documentId: user.$id,
          data: profile.toJson(),
        );
      } catch (e) {
        // Document doesn't exist, create new
        await databases.createDocument(
          databaseId: databaseId,
          collectionId: usersCollection,
          documentId: user.$id,
          data: profile.toJson(),
        );
      }
    } catch (e) {
      // Log error but don't fail the onboarding
      print('Failed to save to Appwrite: $e');
    }
  }

  /// Reset onboarding
  void reset() {
    state = OnboardingState();
  }
}

/// Onboarding provider
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});

/// Current onboarding step provider
final onboardingStepProvider = Provider<OnboardingStep>((ref) {
  return ref.watch(onboardingProvider).currentStep;
});

/// Onboarding progress provider (0.0 to 1.0)
final onboardingProgressProvider = Provider<double>((ref) {
  final step = ref.watch(onboardingStepProvider);
  return step.stepIndex / OnboardingStep.completed.stepIndex;
});
