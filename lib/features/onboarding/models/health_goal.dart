import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class HealthGoal {
  final String id;
  final String title;
  final String icon; // Emoji character
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
    title: 'Lose Weight',
    icon: '🏃',
    color: AppColorsDark.error,
  ),
  HealthGoal(
    id: 'muscle_gain',
    title: 'Build Muscle',
    icon: '💪',
    color: AppColorsDark.secondary,
  ),
  HealthGoal(
    id: 'heart_health',
    title: 'Heart Health',
    icon: '❤️',
    color: AppColorsDark.primary,
  ),
  HealthGoal(
    id: 'manage_bp_glucose',
    title: 'Manage BP / Glucose',
    icon: '🩸',
    color: AppColorsDark.rose,
  ),
  HealthGoal(
    id: 'reduce_stress',
    title: 'Reduce Stress',
    icon: '🧘',
    color: AppColorsDark.teal,
  ),
  HealthGoal(
    id: 'energy_boost',
    title: 'More Energy',
    icon: '⚡',
    color: AppColorsDark.warning,
  ),
];
