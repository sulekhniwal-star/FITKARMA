import 'package:flutter/material.dart';

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
    color: Color(0xFFF87171),
  ),
  HealthGoal(
    id: 'muscle_gain',
    title: 'Muscle Gain',
    icon: '💪',
    color: Color(0xFF60A5FA),
  ),
  HealthGoal(
    id: 'better_sleep',
    title: 'Better Sleep',
    icon: '😴',
    color: Color(0xFFC084FC),
  ),
  HealthGoal(
    id: 'mental_clarity',
    title: 'Mental Clarity',
    icon: '🧘',
    color: Color(0xFF2DD4BF),
  ),
  HealthGoal(
    id: 'energy_boost',
    title: 'Energy Boost',
    icon: '⚡',
    color: Color(0xFFFBBF24),
  ),
  HealthGoal(
    id: 'flexibility',
    title: 'Flexibility',
    icon: '🤸',
    color: Color(0xFFFB7185),
  ),
  HealthGoal(
    id: 'heart_health',
    title: 'Heart Health',
    icon: '❤️',
    color: Color(0xFFEF4444),
  ),
  HealthGoal(
    id: 'longevity',
    title: 'Longevity',
    icon: '⏳',
    color: Color(0xFF34D399),
  ),
];
