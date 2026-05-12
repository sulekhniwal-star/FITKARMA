import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/device_tier.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/providers/low_data_mode_provider.dart';

/// GlassCard — A premium, tier-aware glassmorphic container.
///
/// Automatically scales visual complexity based on [DeviceTier].
/// - Low Tier: Solid surface background.
/// - Mid/High Tier: Real-time backdrop blur.
class GlassCard extends ConsumerWidget {
  final Widget child;
  final Color? glowColor;
  final double? customRadius;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.glowColor,
    this.customRadius,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tier = ref.watch(deviceTierProvider).value ?? DeviceTier.mid;
    final isLowData = ref.watch(lowDataModeProvider).value ?? false;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = customRadius ?? AppRadius.md;

    Widget cardContent = Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.cardH),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.glass : AppColorsLight.glass,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: isDark ? AppColorsDark.glassBorder : AppColorsLight.glassBorder,
        ),
        boxShadow: glowColor != null
            ? [
                BoxShadow(
                  color: glowColor!.withValues(alpha: tier == DeviceTier.low ? 0.15 : 0.25),
                  blurRadius: tier == DeviceTier.low ? 12 : 24,
                  spreadRadius: -4,
                )
              ]
            : null,
      ),
      child: child,
    );

    // Apply Blur for Mid/High Tiers, unless Low Data Mode is active
    if (tier != DeviceTier.low && !isLowData) {
      cardContent = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: tier == DeviceTier.high ? 16 : 12,
            sigmaY: tier == DeviceTier.high ? 16 : 12,
          ),
          child: cardContent,
        ),
      );
    } else {
      // Fallback to solid surface for Low Tier
      cardContent = Container(
        padding: padding ?? const EdgeInsets.all(AppSpacing.cardH),
        decoration: BoxDecoration(
          color: isDark ? AppColorsDark.surface1 : AppColorsLight.surface1,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: isDark ? AppColorsDark.glassBorder : AppColorsLight.glassBorder,
          ),
        ),
        child: child,
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: cardContent,
      );
    }

    return cardContent;
  }
}
