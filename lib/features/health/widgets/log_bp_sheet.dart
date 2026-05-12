import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../bp_providers.dart';

class LogBpSheet extends ConsumerStatefulWidget {
  const LogBpSheet({super.key});

  @override
  ConsumerState<LogBpSheet> createState() => _LogBpSheetState();
}

class _LogBpSheetState extends ConsumerState<LogBpSheet> {
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _pulseController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedArm = 'Left';

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _pulseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveReading() async {
    final systolic = int.tryParse(_systolicController.text.trim());
    final diastolic = int.tryParse(_diastolicController.text.trim());
    final pulse = int.tryParse(_pulseController.text.trim());

    if (systolic == null || systolic < 50 || systolic > 250) {
      setState(() => _errorMessage = 'Please enter a valid systolic value (50-250)');
      return;
    }
    if (diastolic == null || diastolic < 30 || diastolic > 150) {
      setState(() => _errorMessage = 'Please enter a valid diastolic value (30-150)');
      return;
    }
    if (pulse == null || pulse < 30 || pulse > 200) {
      setState(() => _errorMessage = 'Please enter a valid pulse value (30-200)');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final notes = _notesController.text.trim().isEmpty ? null : _notesController.text.trim();
      await logBpReading(
        ref,
        systolic: systolic,
        diastolic: diastolic,
        pulse: pulse,
        notes: notes,
        arm: _selectedArm,
      );

      final classification = BpClassification.classify(systolic, diastolic);

      if (mounted) {
        Navigator.pop(context);

        // If Hypertensive Crisis, show immediate alert dialog
        if (classification == BpClassification.crisis) {
          _showCrisisDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Reading saved: $systolic/$diastolic mmHg (${classification.label})'),
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

  void _showCrisisDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColorsDark.surface1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColorsDark.error, size: 28),
            const SizedBox(width: 12),
            Text('Hypertensive Crisis', style: AppTypography.h2(color: AppColorsDark.error)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your blood pressure reading is severely elevated. Please rest for 5 minutes and test again.',
              style: AppTypography.bodyMd(color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              'If your readings remain above 180/120 mmHg or you are experiencing chest pain, shortness of breath, back pain, numbness/weakness, or difficulty speaking, do not wait. Call emergency medical services immediately.',
              style: AppTypography.bodySm(color: AppColorsDark.rose),
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
              backgroundColor: AppColorsDark.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              // In real app: call emergency intent
            },
            child: const Text('Emergency Services'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen inset for keyboard avoiding
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
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
                Text('Log Blood Pressure', style: AppTypography.h2(color: Colors.white)),
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
                  color: AppColorsDark.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColorsDark.error.withOpacity(0.3)),
                ),
                child: Text(
                  _errorMessage!,
                  style: AppTypography.bodySm(color: AppColorsDark.rose),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Input Fields Row: Systolic & Diastolic
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    controller: _systolicController,
                    label: 'Systolic',
                    hint: '120',
                    unit: 'mmHg',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('/', style: TextStyle(color: AppColorsDark.textMuted, fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: _buildInputField(
                    controller: _diastolicController,
                    label: 'Diastolic',
                    hint: '80',
                    unit: 'mmHg',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Pulse Field
            _buildInputField(
              controller: _pulseController,
              label: 'Heart Rate (Pulse)',
              hint: '72',
              unit: 'bpm',
            ),
            const SizedBox(height: 20),

            // Arm Selector
            Text('Measured Arm', style: AppTypography.labelMd(color: AppColorsDark.textSecondary)),
            const SizedBox(height: 8),
            Row(
              children: ['Left', 'Right'].map((arm) {
                final isSelected = _selectedArm == arm;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: arm == 'Left' ? 12 : 0),
                    child: ChoiceChip(
                      label: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text('$arm Arm'),
                      ),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) setState(() => _selectedArm = arm);
                      },
                      selectedColor: AppColorsDark.primary.withOpacity(0.2),
                      backgroundColor: AppColorsDark.surface1,
                      side: BorderSide(
                        color: isSelected ? AppColorsDark.primary : AppColorsDark.surface2,
                      ),
                      labelStyle: AppTypography.labelLg(
                        color: isSelected ? AppColorsDark.primary : AppColorsDark.textSecondary,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                );
              }).toList(),
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
                hintText: 'e.g., After medication, resting, dizzy...',
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
                  : Text('Save Reading', style: AppTypography.labelLg(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String unit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelMd(color: AppColorsDark.textSecondary)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: AppTypography.metricLg(color: Colors.white).copyWith(fontSize: 24),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.metricLg(color: AppColorsDark.textMuted).copyWith(fontSize: 24),
            suffixText: unit,
            suffixStyle: AppTypography.labelSm(color: AppColorsDark.textMuted),
            filled: true,
            fillColor: AppColorsDark.surface1,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
