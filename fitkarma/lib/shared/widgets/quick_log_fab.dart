import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Quick log FAB (Floating Action Button)
///
/// Speed-dial FAB with sub-actions for quick logging
/// Per Section 2.1 Dashboard Screen - Quick-Log FAB
/// Orange circular FAB with + icon, positioned at bottom-right above nav bar
class QuickLogFab extends StatefulWidget {
  /// List of speed dial actions
  final List<SpeedDialAction> actions;

  /// Whether the FAB is expanded
  final bool isExtended;

  /// Icon for the main FAB
  final IconData icon;

  /// Background color
  final Color? backgroundColor;

  /// Icon color
  final Color? foregroundColor;

  const QuickLogFab({
    super.key,
    required this.actions,
    this.isExtended = false,
    this.icon = Icons.add,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  State<QuickLogFab> createState() => _QuickLogFabState();
}

class _QuickLogFabState extends State<QuickLogFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Speed dial actions
        ...List.generate(widget.actions.length, (index) {
          final action = widget.actions[index];
          final delay = index * 0.1;

          return _SpeedDialAction(
            action: action,
            animation: _expandAnimation,
            delay: delay,
          );
        }),
        const SizedBox(height: 8),
        // Main FAB
        _MainFab(
          isOpen: _isOpen,
          icon: widget.icon,
          onPressed: _toggle,
          backgroundColor: widget.backgroundColor,
          foregroundColor: widget.foregroundColor,
          isExtended: widget.isExtended,
        ),
      ],
    );
  }
}

/// Main FAB button
class _MainFab extends StatelessWidget {
  final bool isOpen;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isExtended;

  const _MainFab({
    required this.isOpen,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.isExtended = false,
  });

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 0.125).animate(
        CurvedAnimation(
          parent: AlwaysStoppedAnimation(isOpen ? 1 : 0),
          curve: Curves.easeInOut,
        ),
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: foregroundColor ?? AppColors.textOnPrimary,
        elevation: 4,
        child: Icon(icon),
      ),
    );
  }
}

/// Speed dial action item
class _SpeedDialAction extends StatelessWidget {
  final SpeedDialAction action;
  final Animation<double> animation;
  final double delay;

  const _SpeedDialAction({
    required this.action,
    required this.animation,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final value = Curves.easeOut.transform(
          Interval(delay, 1.0).transform(animation.value),
        );

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label
            if (action.label != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  action.label!,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (action.label != null) const SizedBox(width: 8),
            // Action FAB
            FloatingActionButton.small(
              onPressed: action.onPressed,
              backgroundColor: action.backgroundColor ?? AppColors.secondary,
              foregroundColor: action.foregroundColor ?? Colors.white,
              heroTag: action.heroTag,
              child: Icon(action.icon),
            ),
          ],
        ),
      ),
    );
  }
}

/// Speed dial action data
class SpeedDialAction {
  /// Icon for the action
  final IconData icon;

  /// Label for the action (optional)
  final String? label;

  /// Callback when action is pressed
  final VoidCallback? onPressed;

  /// Background color
  final Color? backgroundColor;

  /// Foreground color
  final Color? foregroundColor;

  /// Hero tag for the FAB
  final String? heroTag;

  const SpeedDialAction({
    required this.icon,
    this.label,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.heroTag,
  });

  /// Factory for common food logging actions
  static List<SpeedDialAction> get foodLogActions => [
    const SpeedDialAction(
      icon: Icons.restaurant,
      label: 'Food',
      heroTag: 'fab_food',
    ),
    const SpeedDialAction(
      icon: Icons.water_drop,
      label: 'Water',
      heroTag: 'fab_water',
    ),
    const SpeedDialAction(
      icon: Icons.directions_run,
      label: 'Workout',
      heroTag: 'fab_workout',
    ),
    const SpeedDialAction(
      icon: Icons.monitor_weight,
      label: 'Weight',
      heroTag: 'fab_weight',
    ),
  ];
}

/// Mini quick log FAB (collapsed state only)
class QuickLogFabMini extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const QuickLogFabMini({
    super.key,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? AppColors.textOnPrimary,
      elevation: 4,
      child: const Icon(Icons.add),
    );
  }
}
