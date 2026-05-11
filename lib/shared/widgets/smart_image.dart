import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/low_data_mode_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// SmartImage — A data-aware image widget.
/// 
/// In Low Data Mode, it displays an emoji placeholder instead of fetching remote bytes.
class SmartImage extends ConsumerWidget {
  final String imageUrl;
  final String emoji;
  final double? width;
  final double? height;
  final BoxFit fit;

  const SmartImage({
    super.key,
    required this.imageUrl,
    this.emoji = '🖼️',
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLowData = ref.watch(lowDataModeProvider).valueOrNull ?? false;

    if (isLowData) {
      return Container(
        width: width,
        height: height,
        color: AppColorsDark.surface2,
        child: Center(
          child: Text(
            emoji,
            style: AppTypography.h1(),
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Container(
        color: AppColorsDark.surface2,
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColorsDark.surface2,
        child: const Icon(Icons.error_outline),
      ),
    );
  }
}
