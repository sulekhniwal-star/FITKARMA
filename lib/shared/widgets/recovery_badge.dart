import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../health/readiness_engine.dart';

class RecoveryBadge extends StatelessWidget {
  final int score;
  final String zoneName;

  const RecoveryBadge({
    super.key,
    required this.score,
    required this.zoneName,
  });

  @override
  Widget build(BuildContext context) {
    // Map zone name to enum
    final zoneEnum = ReadinessZone.values.firstWhere(
      (e) => e.name == zoneName,
      orElse: () => ReadinessZone.moderate,
    );

    final result = ReadinessEngine.calculate(
      sleepMinutes: 480, // default dummy
      sleepQuality: 8,
      sorenessLevel: 2,
      stressLevel: 2,
      energyLevel: 8,
    ); // We can just resolve color by matching ReadinessZone

    Color zoneColor;
    String label;
    switch (zoneEnum) {
      case ReadinessZone.optimal:
        zoneColor = const Color(0xFF4CAF50);
        label = 'Optimal';
      case ReadinessZone.good:
        zoneColor = const Color(0xFF00BFA5);
        label = 'Good';
      case ReadinessZone.moderate:
        zoneColor = const Color(0xFFFFB300);
        label = 'Moderate';
      case ReadinessZone.low:
        zoneColor = const Color(0xFFFF9100);
        label = 'Low';
      case ReadinessZone.rest:
        zoneColor = const Color(0xFFFF5252);
        label = 'Rest';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: zoneColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: zoneColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: zoneColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$label · $score',
            style: AppTypography.labelSm(color: AppColorsDark.textPrimary).copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
