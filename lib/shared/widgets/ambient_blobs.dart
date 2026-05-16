import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/low_data_mode_provider.dart';

/// AmbientBlobs — Soft, blurry background blobs for depth and atmosphere.
///
/// Automatically disabled in Low Data Mode to save resources.
class AmbientBlobs extends ConsumerWidget {
  const AmbientBlobs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLowData = ref.watch(lowDataModeProvider).value ?? false;

    if (isLowData) return const SizedBox.shrink();

    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: _Blob(
            color: AppColorsDark.primaryMuted.withValues(alpha: 0.15),
            size: 400,
          ),
        ),
        Positioned(
          bottom: -50,
          left: -100,
          child: _Blob(
            color: AppColorsDark.secondaryGlow.withValues(alpha: 0.1),
            size: 350,
          ),
        ),
        Positioned(
          top: 300,
          left: -50,
          child: _Blob(
            color: AppColorsDark.tealGlow.withValues(alpha: 0.08),
            size: 250,
          ),
        ),
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;

  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              color.withValues(alpha: 0),
            ],
            stops: const [0.1, 1.0],
          ),
        ),
      ),
    );
  }
}
