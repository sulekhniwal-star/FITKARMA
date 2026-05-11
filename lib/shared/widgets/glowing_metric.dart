import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/device_tier.dart';
import '../../core/theme/app_typography.dart';

/// GlowingMetric — A hero text element with an ambient glow background.
/// 
/// Designed to be the single dominant focal point of a screen.
/// Glow is automatically reduced on [DeviceTier.mid] and disabled on [DeviceTier.low].
class GlowingMetric extends ConsumerWidget {
  final String value;
  final String? unit;
  final Color glowColor;
  final TextStyle? textStyle;

  const GlowingMetric({
    super.key,
    required this.value,
    this.unit,
    required this.glowColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tier = ref.watch(deviceTierProvider).valueOrNull ?? DeviceTier.mid;
    
    return Stack(
      alignment: Alignment.center,
      children: [
        // Ambient Glow (Gated by DeviceTier)
        if (tier != DeviceTier.low)
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: glowColor.withOpacity(tier == DeviceTier.high ? 0.25 : 0.15),
                  blurRadius: tier == DeviceTier.high ? 80 : 40,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),

        // Metric Text
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: textStyle ?? AppTypography.heroDisplay(),
            ),
            if (unit != null)
              Text(
                unit!,
                style: AppTypography.labelLg().copyWith(
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
