import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'ambient_blobs.dart';
import 'quick_log_fab.dart';

/// AppScaffold — Unified scaffold patterns for FitKarma.
class AppScaffold extends StatelessWidget {
  final Widget body;
  final Widget? appBar;
  final Widget? floatingActionButton;
  final bool useBlobs;
  final bool extendBody;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.useBlobs = true,
    this.extendBody = false,
    this.backgroundColor,
  });

  /// Pattern A — Standard Scroll
  /// Used for Dashboard, Food, Steps, Karma, etc.
  factory AppScaffold.patternA({
    required Widget body,
    Widget? appBar,
    bool showFab = true,
  }) {
    return AppScaffold(
      appBar: appBar,
      floatingActionButton: showFab ? const QuickLogFab() : null,
      useBlobs: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenH,
            0,
            AppSpacing.screenH,
            AppSpacing.fabClearance,
          ),
          child: body,
        ),
      ),
    );
  }

  /// Pattern B — Hero + Overlapping Body
  /// Used for Profile, BP, Glucose, Sleep.
  static Widget patternB({
    required Widget hero,
    required Widget body,
    Widget? appBar,
    Color? heroColor,
    Gradient? heroGradient,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 900;

        if (isWide) {
          final AppBar? bar = appBar is AppBar ? appBar : null;
          return Scaffold(
            backgroundColor: AppColorsDark.bg1,
            body: Row(
              children: [
                // Desktop Sidebar Hero
                Container(
                  width: 320,
                  decoration: BoxDecoration(
                    color: heroColor,
                    gradient: heroGradient,
                  ),
                  child: SafeArea(
                    child: Stack(
                      children: [
                        if (bar?.leading != null)
                          Positioned(top: 12, left: 12, child: bar!.leading!),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Center(child: hero),
                        ),
                      ],
                    ),
                  ),
                ),
                // Main Content Area
                Expanded(
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: bar != null
                        ? AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            automaticallyImplyLeading: false,
                            title: bar.title,
                            centerTitle: true,
                            actions: bar.actions,
                          )
                        : null,
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxl,
                        vertical: AppSpacing.lg,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 900),
                          child: body,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Standard Mobile Layout
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: appBar as PreferredSizeWidget?,
          body: Stack(
            children: [
              // Hero Section
              Container(
                height: 320,
                decoration: BoxDecoration(
                  color: heroColor,
                  gradient: heroGradient,
                ),
                child: SafeArea(child: hero),
              ),
              // Overlapping Body
              Positioned(
                top: 292,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColorsDark.bg1,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
                    child: body,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Pattern C — Full Bleed
  /// Used for Active Workout, Breathing, Logo Reveal.
  static Widget patternC({
    required Widget body,
    Gradient? gradient,
  }) {
    return Scaffold(
      backgroundColor: AppColorsDark.bg0,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          if (gradient != null)
            Container(decoration: BoxDecoration(gradient: gradient)),
          SafeArea(child: body),
        ],
      ),
    );
  }

  /// Calm Zone
  /// Used for Settings, Journal, Emergency.
  factory AppScaffold.calmZone({
    required Widget body,
    Widget? appBar,
  }) {
    return AppScaffold(
      backgroundColor: AppColorsDark.bg2,
      useBlobs: false,
      appBar: appBar,
      body: body,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColorsDark.bg1,
      appBar: appBar as PreferredSizeWidget?,
      extendBody: extendBody,
      body: Stack(
        children: [
          if (useBlobs) const AmbientBlobs(),
          body,
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
