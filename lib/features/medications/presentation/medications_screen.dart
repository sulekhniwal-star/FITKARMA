import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/shimmer_loader.dart';
import '../../../shared/widgets/error_empty_states.dart';
import '../domain/medication_model.dart';
import '../data/medications_repository.dart';

/// Medications list screen - displays all medications with categories
class MedicationsScreen extends ConsumerStatefulWidget {
  const MedicationsScreen({super.key});

  @override
  ConsumerState<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends ConsumerState<MedicationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(medicationsRepositoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Medications',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'दवाइयाँ',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert, color: AppColors.primary),
            onPressed: () => _showRefillAlerts(context, repository),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Rx'),
            Tab(text: 'OTC'),
            Tab(text: 'Ayurvedic'),
          ],
        ),
      ),
      body: FutureBuilder<List<Medication>>(
        future: repository.getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ShimmerLoader(
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return FKErrorWidget(
              message: 'Failed to load medications',
              onRetry: () => setState(() {}),
            );
          }

          final medications = snapshot.data ?? [];

          if (medications.isEmpty) {
            return EmptyState(
              emoji: '💊',
              title: 'No Medications Added',
              subtitle: 'Add your medications to track and get reminders',
              ctaText: 'Add Medication',
              onCtaPressed: () => context.push('/medications/add'),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildMedicationsList(medications),
              _buildMedicationsList(
                medications
                    .where((m) => m.category == MedicationCategory.prescription)
                    .toList(),
              ),
              _buildMedicationsList(
                medications
                    .where((m) => m.category == MedicationCategory.otc)
                    .toList(),
              ),
              _buildMedicationsList(
                medications
                    .where((m) => m.category == MedicationCategory.ayurvedic)
                    .toList(),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/medications/add'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildMedicationsList(List<Medication> medications) {
    if (medications.isEmpty) {
      return const Center(child: Text('No medications in this category'));
    }

    // Group by active/inactive
    final active = medications.where((m) => m.isActive && !m.hasEnded).toList();
    final inactive = medications
        .where((m) => !m.isActive || m.hasEnded)
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (active.isNotEmpty) ...[
          const SectionHeader(
            englishTitle: 'Active Medications',
            hindiSubtitle: 'सक्रिय दवाइयाँ',
          ),
          ...active.map(
            (med) => _MedicationCard(
              medication: med,
              onTap: () => context.push('/medications/${med.id}'),
              onToggle: () => _toggleMedication(med.id),
              onDelete: () => _deleteMedication(med.id),
            ),
          ),
        ],
        if (inactive.isNotEmpty) ...[
          const SizedBox(height: 16),
          const SectionHeader(
            englishTitle: 'Inactive',
            hindiSubtitle: 'निष्क्रिय',
          ),
          ...inactive.map(
            (med) => _MedicationCard(
              medication: med,
              onTap: () => context.push('/medications/${med.id}'),
              onToggle: () => _toggleMedication(med.id),
              onDelete: () => _deleteMedication(med.id),
            ),
          ),
        ],
      ],
    );
  }

  void _toggleMedication(String id) async {
    final repository = ref.read(medicationsRepositoryProvider);
    await repository.toggleActive(id);
    setState(() {});
  }

  void _deleteMedication(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medication'),
        content: const Text('Are you sure you want to delete this medication?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final repository = ref.read(medicationsRepositoryProvider);
      await repository.deleteMedication(id);
      setState(() {});
    }
  }

  void _showRefillAlerts(
    BuildContext context,
    MedicationsRepository repository,
  ) async {
    final needsRefill = await repository.getMedicationsNeedingRefill();

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber, color: AppColors.accent),
                const SizedBox(width: 8),
                Text('Refill Alerts', style: AppTextStyles.h3),
              ],
            ),
            const SizedBox(height: 16),
            if (needsRefill.isEmpty)
              const Text('No medications need refill soon!')
            else
              ...needsRefill.map(
                (med) => ListTile(
                  leading: const Icon(Icons.medication),
                  title: Text(med.name),
                  subtitle: med.refillDate != null
                      ? Text('Refill by ${_formatDate(med.refillDate!)}')
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _MedicationCard extends StatelessWidget {
  final Medication medication;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _MedicationCard({
    required this.medication,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(medication.category);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(medication.category),
                      color: categoryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medication.name,
                          style: AppTextStyles.h4.copyWith(
                            fontWeight: FontWeight.bold,
                            color: medication.isActive
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                        Text(medication.dosage, style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'toggle') onToggle();
                      if (value == 'delete') onDelete();
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'toggle',
                        child: Text(
                          medication.isActive ? 'Deactivate' : 'Activate',
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      medication.frequencyDisplay,
                      style: AppTextStyles.caption,
                    ),
                  ),
                  if (medication.refillNeeded)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.warning_amber,
                            size: 14,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Refill',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              if (medication.categoryLabel.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    medication.categoryLabel,
                    style: AppTextStyles.caption.copyWith(color: categoryColor),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(MedicationCategory category) {
    switch (category) {
      case MedicationCategory.prescription:
        return AppColors.primary;
      case MedicationCategory.otc:
        return AppColors.teal;
      case MedicationCategory.supplement:
        return AppColors.purple;
      case MedicationCategory.ayurvedic:
        return AppColors.success;
    }
  }

  IconData _getCategoryIcon(MedicationCategory category) {
    switch (category) {
      case MedicationCategory.prescription:
        return Icons.medical_services;
      case MedicationCategory.otc:
        return Icons.medication_liquid;
      case MedicationCategory.supplement:
        return Icons.medication;
      case MedicationCategory.ayurvedic:
        return Icons.spa;
    }
  }
}
