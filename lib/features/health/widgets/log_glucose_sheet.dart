import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../glucose_providers.dart';

class LogGlucoseSheet extends ConsumerStatefulWidget {
  const LogGlucoseSheet({super.key});

  @override
  ConsumerState<LogGlucoseSheet> createState() => _LogGlucoseSheetState();
}

class _LogGlucoseSheetState extends ConsumerState<LogGlucoseSheet> {
  final _valueController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedTiming = 'fasting'; // fasting, post-meal, random, bedtime
  String? _selectedFoodName;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _valueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveReading() async {
    final value = double.tryParse(_valueController.text.trim());

    if (value == null || value < 10 || value > 600) {
      setState(() => _errorMessage = 'Please enter a valid glucose value (10-600 mg/dL)');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final notes = _notesController.text.trim().isEmpty ? null : _notesController.text.trim();
      await logGlucoseReading(
        ref,
        value: value,
        timing: _selectedTiming,
        notes: notes,
        linkedFood: _selectedFoodName,
      );

      final isCrisis = GlucoseClassification.isCrisis(value);
      final classification = GlucoseClassification.classify(value, _selectedTiming);

      if (mounted) {
        Navigator.pop(context);

        if (isCrisis) {
          _showCrisisDialog(value);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Glucose logged: ${value.toInt()} mg/dL (${classification.label})'),
              backgroundColor: classification.color,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to save reading. Please try again.';
        });
      }
    }
  }

  void _showCrisisDialog(double value) {
    final isLow = value < 54;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColorsDark.surface1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: isLow ? AppColorsDark.purple : AppColorsDark.error,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              isLow ? 'Severe Hypoglycemia' : 'Severe Hyperglycemia',
              style: AppTypography.h2(color: isLow ? AppColorsDark.purple : AppColorsDark.error),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isLow
                  ? 'Your blood sugar is critically low (${value.toInt()} mg/dL). Immediate action is required to prevent loss of consciousness.'
                  : 'Your blood sugar is critically high (${value.toInt()} mg/dL). Risk of diabetic ketoacidosis (DKA).',
              style: AppTypography.bodyMd(color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              isLow
                  ? 'Protocol: Consume 15g of fast-acting carbohydrates immediately (e.g., 4 oz fruit juice, 3-4 glucose tablets, or 1 tbsp sugar/honey). Rest and re-test in 15 minutes. If symptoms worsen or do not improve, call emergency services.'
                  : 'Protocol: Drink plenty of water and test for ketones if possible. If you experience nausea, vomiting, confusion, abdominal pain, or shortness of breath, seek emergency medical care immediately.',
              style: AppTypography.bodySm(color: isLow ? AppColorsDark.textSecondary : AppColorsDark.rose),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('I Understand', style: TextStyle(color: AppColorsDark.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isLow ? AppColorsDark.purple : AppColorsDark.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              // Trigger emergency calling intent if available
            },
            child: const Text('Emergency Assistance'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final foodLogsAsync = ref.watch(todayFoodLogsProvider);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.92,
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
      decoration: const BoxDecoration(
        color: AppColorsDark.surface0,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColorsDark.surface2,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Log Blood Glucose', style: AppTypography.h2(color: Colors.white)),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColorsDark.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColorsDark.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColorsDark.error.withValues(alpha: 0.3)),
                ),
                child: Text(
                  _errorMessage!,
                  style: AppTypography.bodySm(color: AppColorsDark.rose),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Glucose Value Input
            Text('Concentration', style: AppTypography.labelMd(color: AppColorsDark.textSecondary)),
            const SizedBox(height: 8),
            TextField(
              controller: _valueController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: AppTypography.metricLg(color: Colors.white).copyWith(fontSize: 32),
              decoration: InputDecoration(
                hintText: '105',
                hintStyle: AppTypography.metricLg(color: AppColorsDark.textMuted).copyWith(fontSize: 32),
                suffixText: 'mg/dL',
                suffixStyle: AppTypography.labelLg(color: AppColorsDark.textMuted),
                filled: true,
                fillColor: AppColorsDark.surface1,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Timing Selector
            Text('Measurement Context', style: AppTypography.labelMd(color: AppColorsDark.textSecondary)),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 3.0,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _buildTimingOption('fasting', 'Fasting', Icons.wb_twilight_rounded),
                _buildTimingOption('post-meal', 'Post-Meal', Icons.restaurant_rounded),
                _buildTimingOption('random', 'Random', Icons.shuffle_rounded),
                _buildTimingOption('bedtime', 'Bedtime', Icons.bedtime_rounded),
              ],
            ),
            const SizedBox(height: 20),

            // Optional Food Linking
            Text('Link to Today\'s Food Log (Optional)', style: AppTypography.labelMd(color: AppColorsDark.textSecondary)),
            const SizedBox(height: 8),
            foodLogsAsync.when(
              loading: () => const Center(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2)),
              )),
              error: (_, _) => Text('Could not load meals', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
              data: (foods) {
                if (foods.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColorsDark.surface1, borderRadius: BorderRadius.circular(12)),
                    child: Text('No meals logged today yet.', style: AppTypography.bodySm(color: AppColorsDark.textMuted)),
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: foods.map((food) {
                      final isSelected = _selectedFoodName == food.name;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(food.name),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFoodName = selected ? food.name : null;
                            });
                          },
                          selectedColor: AppColorsDark.teal.withValues(alpha: 0.2),
                          backgroundColor: AppColorsDark.surface1,
                          checkmarkColor: AppColorsDark.teal,
                          side: BorderSide(color: isSelected ? AppColorsDark.teal : AppColorsDark.surface2),
                          labelStyle: AppTypography.labelSm(
                            color: isSelected ? AppColorsDark.teal : AppColorsDark.textSecondary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Notes field
            Text('Notes (Optional)', style: AppTypography.labelMd(color: AppColorsDark.textSecondary)),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              style: const TextStyle(color: Colors.white),
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'e.g., Felt shaky, post-workout, ate sweets...',
                hintStyle: AppTypography.bodyMd(color: AppColorsDark.textMuted),
                filled: true,
                fillColor: AppColorsDark.surface1,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorsDark.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
              onPressed: _isLoading ? null : _saveReading,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text('Save Glucose Reading', style: AppTypography.labelLg(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimingOption(String id, String label, IconData icon) {
    final isSelected = _selectedTiming == id;
    return InkWell(
      onTap: () => setState(() => _selectedTiming = id),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColorsDark.primary.withValues(alpha: 0.15) : AppColorsDark.surface1,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColorsDark.primary : AppColorsDark.surface2,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? AppColorsDark.primary : AppColorsDark.textSecondary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: AppTypography.labelSm(
                  color: isSelected ? AppColorsDark.primary : AppColorsDark.textSecondary,
                ).copyWith(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
