// lib/features/insight_engine/widgets/insight_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../rule_engine.dart';
import '../insight_providers.dart';

/// Insight card widget for displaying on dashboard
class InsightCard extends ConsumerWidget {
  final InsightResult insight;
  final VoidCallback? onDismiss;

  const InsightCard({super.key, required this.insight, this.onDismiss});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(color: _getSeverityColor(), width: 4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    insight.severity.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      insight.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildSeverityBadge(context),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                insight.message,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [_buildFeedbackButtons(context, ref)],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeverityBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getSeverityColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        insight.severity.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _getSeverityColor(),
        ),
      ),
    );
  }

  Widget _buildFeedbackButtons(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Was this helpful?',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.thumb_up_outlined, size: 20),
          onPressed: () async {
            final store = ref.read(insightFeedbackProvider);
            await store.recordFeedback(insight.id, InsightFeedback.thumbsUp);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thanks for your feedback!'),
                  duration: Duration(seconds: 1),
                ),
              );
            }
          },
          tooltip: 'Helpful',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        IconButton(
          icon: const Icon(Icons.thumb_down_outlined, size: 20),
          onPressed: () async {
            final store = ref.read(insightFeedbackProvider);
            await store.recordFeedback(insight.id, InsightFeedback.thumbsDown);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('We\'ll show less of this'),
                  duration: Duration(seconds: 1),
                ),
              );
            }
          },
          tooltip: 'Not helpful',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ],
    );
  }

  Color _getSeverityColor() {
    switch (insight.severity) {
      case InsightSeverity.info:
        return Colors.blue;
      case InsightSeverity.success:
        return Colors.green;
      case InsightSeverity.warning:
        return Colors.orange;
      case InsightSeverity.danger:
        return Colors.red;
    }
  }
}

/// Widget to display multiple insight cards
class InsightCardsList extends ConsumerWidget {
  final int maxCards;

  const InsightCardsList({super.key, this.maxCards = 2});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(todayInsightsProvider);

    return insightsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, st) => const SizedBox.shrink(),
      data: (insights) {
        if (insights.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Insights for You',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ...insights
                .take(maxCards)
                .map(
                  (insight) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: InsightCard(insight: insight),
                  ),
                ),
          ],
        );
      },
    );
  }
}

/// Compact insight chip for dashboard
class InsightChip extends ConsumerWidget {
  final InsightResult insight;

  const InsightChip({super.key, required this.insight});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ActionChip(
      avatar: Text(insight.severity.emoji),
      label: Text(insight.title),
      backgroundColor: _getSeverityColor().withOpacity(0.1),
      side: BorderSide(color: _getSeverityColor()),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Text(insight.severity.emoji),
                const SizedBox(width: 8),
                Expanded(child: Text(insight.title)),
              ],
            ),
            content: Text(insight.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it'),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getSeverityColor() {
    switch (insight.severity) {
      case InsightSeverity.info:
        return Colors.blue;
      case InsightSeverity.success:
        return Colors.green;
      case InsightSeverity.warning:
        return Colors.orange;
      case InsightSeverity.danger:
        return Colors.red;
    }
  }
}
