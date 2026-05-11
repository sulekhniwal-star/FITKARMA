import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom spring-based page transitions for FitKarma.
class AppTransitions {
  AppTransitions._();

  static CustomTransitionPage springSlideFade({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 600),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeIn,
          ),
          child: SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.elasticOut)),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
