import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class HealthGoal {
  final String id;
  final String title;
  final String icon; // Icon name or character
  final Color color;

  const HealthGoal({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}

const List<HealthGoal> availableGoals = [
  HealthGoal(
    id: 'weight_loss',
    title: 'Weight Loss',
    icon: '🔥',
    color: AppColorsDark.error,
  ),
  HealthGoal(
    id: 'muscle_gain',
    title: 'Muscle Gain',
    icon: '💪',
    color: AppColorsDark.secondary,
  ),
  HealthGoal(
    id: 'better_sleep',
    title: 'Better Sleep',
    icon: '😴',
    color: AppColorsDark.purple,
  ),
  HealthGoal(
    id: 'mental_clarity',
    title: 'Mental Clarity',
    icon: '🧘',
    color: AppColorsDark.teal,
  ),
  HealthGoal(
    id: 'energy_boost',
    title: 'Energy Boost',
    icon: '⚡',
    color: AppColorsDark.warning,
  ),
  HealthGoal(
    id: 'flexibility',
    title: 'Flexibility',
    icon: '🤸',
    color: AppColorsDark.rose,
  ),
  HealthGoal(
    id: 'heart_health',
    title: 'Heart Health',
    icon: '❤️',
    color: AppColorsDark.primary,
  ),
  HealthGoal(
    id: 'longevity',
    title: 'Longevity',
    icon: '⏳',
    color: AppColorsDark.success,
  ),
];
