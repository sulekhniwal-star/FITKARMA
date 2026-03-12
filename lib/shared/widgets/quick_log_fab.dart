import 'package:flutter/material.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_text_styles.dart';

class QuickLogFAB extends StatefulWidget {
  const QuickLogFAB({super.key});

  @override
  State<QuickLogFAB> createState() => _QuickLogFABState();
}

class _QuickLogFABState extends State<QuickLogFAB> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _expandAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.125).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    ); // 0.125 * 2pi = 45 degrees
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeIn,
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

  Widget _buildDialItem({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Text(label, style: AppTextStyles.labelMedium),
          ),
          const SizedBox(width: 12),
          FloatingActionButton.small(
            heroTag: label, // unique tag to prevent hero errors
            backgroundColor: color,
            foregroundColor: AppColors.white,
            elevation: 4,
            onPressed: () {
              _toggle();
              onTap();
            },
            child: Icon(icon, size: 20),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_isOpen)
          GestureDetector(
            onTap: _toggle,
            behavior: HitTestBehavior.opaque,
            child: Container(
              color: Colors.transparent,
              height: 1,
              width: 1, // Full screen tap blocker logic would be handled by scaffold, keeping local tree simple here.
            ),
          ),
        SizeTransition(
          sizeFactor: _expandAnimation,
          axisAlignment: 1.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialItem(icon: Icons.monitor_heart, color: AppColors.error, label: 'Glucose', onTap: () {}),
              _buildDialItem(icon: Icons.favorite, color: AppColors.error, label: 'Blood Pressure', onTap: () {}),
              _buildDialItem(icon: Icons.fitness_center, color: AppColors.primary, label: 'Workout', onTap: () {}),
              _buildDialItem(icon: Icons.mood, color: AppColors.purple, label: 'Mood', onTap: () {}),
              _buildDialItem(icon: Icons.water_drop, color: AppColors.teal, label: 'Water', onTap: () {}),
              _buildDialItem(icon: Icons.restaurant, color: AppColors.primary, label: 'Food', onTap: () {}),
            ],
          ),
        ),
        FloatingActionButton(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 4,
          onPressed: _toggle,
          child: RotationTransition(
            turns: _rotationAnimation,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
