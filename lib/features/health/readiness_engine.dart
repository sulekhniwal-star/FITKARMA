import 'package:flutter/material.dart';

enum ReadinessZone {
  optimal,   // 85-100 (Green)
  good,      // 70-84 (Teal)
  moderate,  // 50-69 (Amber)
  low,       // 30-49 (Orange)
  rest,      // <30 (Red)
}

class ReadinessResult {
  final int score;
  final ReadinessZone zone;
  final String recommendation;
  final String workoutIntensity; // 'light'/'moderate'/'intense'/'rest'
  final int waterTargetMl;
  final int stepTarget;

  ReadinessResult({
    required this.score,
    required this.zone,
    required this.recommendation,
    required this.workoutIntensity,
    required this.waterTargetMl,
    required this.stepTarget,
  });

  Color get color {
    switch (zone) {
      case ReadinessZone.optimal:
        return const Color(0xFF4CAF50); // Green
      case ReadinessZone.good:
        return const Color(0xFF00BFA5); // Teal
      case ReadinessZone.moderate:
        return const Color(0xFFFFB300); // Amber
      case ReadinessZone.low:
        return const Color(0xFFFF9100); // Orange
      case ReadinessZone.rest:
        return const Color(0xFFFF5252); // Red
    }
  }

  String get zoneLabel {
    switch (zone) {
      case ReadinessZone.optimal:
        return 'Optimal';
      case ReadinessZone.good:
        return 'Good';
      case ReadinessZone.moderate:
        return 'Moderate';
      case ReadinessZone.low:
        return 'Low';
      case ReadinessZone.rest:
        return 'Rest';
    }
  }
}

class ReadinessEngine {
  static ReadinessResult calculate({
    required int sleepMinutes,
    required int sleepQuality, // 1-10
    required int sorenessLevel, // 1-10 (10 being most sore)
    required int stressLevel, // 1-10 (10 being most stressed)
    required int energyLevel, // 1-10 (10 being highest energy)
    int? restingHr,
  }) {
    // 1. Sleep score (duration and quality)
    // 8 hours (480 mins) is 100% duration
    final double sleepDurationScore = (sleepMinutes / 480.0) * 100.0;
    final double sleepQualityScore = sleepQuality * 10.0;
    final double sleepWeighted = (sleepDurationScore.clamp(0, 100) * 0.6) + (sleepQualityScore.clamp(0, 100) * 0.4);

    // 2. Subjective score (energy, soreness, stress)
    final double sorenessScore = (10 - sorenessLevel) * 10.0;
    final double stressScore = (10 - stressLevel) * 10.0;
    final double energyScore = energyLevel * 10.0;
    final double subjectiveWeighted = (sorenessScore.clamp(0, 100) * 0.4) + 
                                       (stressScore.clamp(0, 100) * 0.3) + 
                                       (energyScore.clamp(0, 100) * 0.3);

    // 3. Resting HR factor (optional)
    double hrDeduction = 0.0;
    if (restingHr != null) {
      if (restingHr > 85) {
        hrDeduction = 15.0; // elevated RHR implies high stress/fatigue
      } else if (restingHr > 75) {
        hrDeduction = 5.0;
      }
    }

    // Combined score
    int score = ((sleepWeighted * 0.5) + (subjectiveWeighted * 0.5) - hrDeduction).round();
    score = score.clamp(10, 100);

    // Determine Zone and intensity
    ReadinessZone zone;
    String workoutIntensity;
    String recommendation;
    int waterTargetMl = 2500;
    int stepTarget = 10000;

    if (score >= 85) {
      zone = ReadinessZone.optimal;
      workoutIntensity = 'intense';
      recommendation = 'You are fully recovered and primed for peak performance. Excellent day for high-intensity training or personal records.';
      waterTargetMl = 3000;
      stepTarget = 12000;
    } else if (score >= 70) {
      zone = ReadinessZone.good;
      workoutIntensity = 'moderate';
      recommendation = 'Good recovery profile. You can handle standard training loads and normal workouts.';
      waterTargetMl = 2500;
      stepTarget = 10000;
    } else if (score >= 50) {
      zone = ReadinessZone.moderate;
      workoutIntensity = 'light';
      recommendation = 'Moderate fatigue detected. Keep workouts focused on volume rather than intensity, or do active recovery.';
      waterTargetMl = 2200;
      stepTarget = 8000;
    } else if (score >= 30) {
      zone = ReadinessZone.low;
      workoutIntensity = 'light';
      recommendation = 'Elevated stress or poor sleep. Focus on stretching, yoga, walking, or mobility work today.';
      waterTargetMl = 2000;
      stepTarget = 6000;
    } else {
      zone = ReadinessZone.rest;
      workoutIntensity = 'rest';
      recommendation = 'System overload. Complete rest and recovery is highly recommended. Hydrate well and rest early.';
      waterTargetMl = 1800;
      stepTarget = 4000;
    }

    return ReadinessResult(
      score: score,
      zone: zone,
      recommendation: recommendation,
      workoutIntensity: workoutIntensity,
      waterTargetMl: waterTargetMl,
      stepTarget: stepTarget,
    );
  }
}
