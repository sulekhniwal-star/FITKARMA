import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../sleep_providers.dart';

class LogSleepSheet extends ConsumerStatefulWidget {
  const LogSleepSheet({super.key});

  @override
  ConsumerState<LogSleepSheet> createState() => _LogSleepSheetState();
}

class _LogSleepSheetState extends ConsumerState<LogSleepSheet> {
  late TimeOfDay _bedtime;
  late TimeOfDay _waketime;
  double _quality = 8.0;

  final _spO2Controller = TextEditingController(text: '97');
  final _hrController = TextEditingController(text: '58');
  final _notesController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Default simulated sleep bounds: 10:30 PM to 6:30 AM
    _bedtime = const TimeOfDay(hour: 22, minute: 30);
    _waketime = const TimeOfDay(hour: 6, minute: 30);
  }

  @override
  void dispose() {
    _spO2Controller.dispose();
    _hrController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(bool isBedtime) async {
    final initial = isBedtime ? _bedtime : _waketime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColorsDark.purple,
              surface: AppColorsDark.surface1,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isBedtime) {
          _bedtime = picked;
        } else {
          _waketime = picked;
        }
      });
    }
  }

  void _pullFromHealthKit() {
    // Simulate auto-populating from native OS background boundary readings
    setState(() {
      _bedtime = const TimeOfDay(hour: 23, minute: 15);
      _waketime = const TimeOfDay(hour: 6, minute: 45);
      _quality = 9.0;
      _spO2Controller.text = '98';
      _hrController.text = '55';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Populated latest session from Apple Health / Google Fit'),
        backgroundColor: AppColorsDark.purple,
      ),
    );
  }

  Future<void> _saveSession() async {
    final spO2 = int.tryParse(_spO2Controller.text.trim());
    final hr = int.tryParse(_hrController.text.trim());

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final now = DateTime.now();
      // Calculate concrete date bounds based on time selections
      DateTime end = DateTime(now.year, now.month, now.day, _waketime.hour, _waketime.minute);
      if (end.isAfter(now)) {
        // If wake time is in the future relative to current hour, assume it was earlier today or yesterday
        end = end.subtract(const Duration(days: 1));
      }

      DateTime start = DateTime(end.year, end.month, end.day, _bedtime.hour, _bedtime.minute);
      if (start.isAfter(end)) {
        start = start.subtract(const Duration(days: 1));
      }

      final notes = _notesController.text.trim().isEmpty ? null : _notesController.text.trim();

      await logSleepSession(
        ref,
        startTime: start,
        endTime: end,
        quality: _quality.toInt(),
        spO2: spO2,
        heartRate: hr,
        notes: notes,
      );

      final duration = end.difference(start);
      final hours = duration.inHours;
      final mins = duration.inMinutes % 60;

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sleep session logged: ${hours}h ${mins}m'),
            backgroundColor: AppColorsDark.purple,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to record sleep session.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

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

            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Log Sleep Session', style: AppTypography.h2(color: Colors.white)),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColorsDark.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Quick Sync action
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColorsDark.purple,
                side: BorderSide(color: AppColorsDark.purple.withOpacity(0.4)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.auto_awesome_rounded, size: 18),
              label: const Text('Auto-Fill via Health Connect / HealthKit'),
              onPressed: _pullFromHealthKit,
            ),
            const SizedBox(height: 20),

            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColorsDark.rose.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Text(_errorMessage!, style: AppTypography.bodySm(color: AppColorsDark.rose)),
              ),
              const SizedBox(height: 16),
            ],

            // Time Selector Cards: Bedtime & Wake Time
            Row(
              children: [
                Expanded(
                  child: _buildTimeCard(
                    label: 'Went to Bed',
                    time: _bedtime,
                    icon: Icons.bedtime_rounded,
                    onTap: () => _selectTime(true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTimeCard(
                    label: 'Woke Up',
                    time: _waketime,
                    icon: Icons.wb_sunny_rounded,
                    onTap: () => _selectTime(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quality Slider
            Text('Sleep Quality Score: ${_quality.toInt()}/10', style: AppTypography.labelMd(color: AppColorsDark.textSecondary)),
            Slider(
              value: _quality,
              min: 1,
              max: 10,
              divisions: 9,
              activeColor: AppColorsDark.purple,
              inactiveColor: AppColorsDark.surface2,
              label: _quality.toInt().toString(),
              onChanged: (val) => setState(() => _quality = val),
            ),
            const SizedBox(height: 16),

            // Biomarkers Row: SpO2 & Heart Rate
            Row(
              children: [
                Expanded(
                  child: _buildBiomarkerInput(
                    controller: _spO2Controller,
                    label: 'Avg SpO2',
                    unit: '%',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildBiomarkerInput(
                    controller: _hrController,
                    label: 'Avg Heart Rate',
                    unit: 'bpm',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Notes
            Text('Journal Notes (Optional)', style: AppTypography.labelMd(color: AppColorsDark.textSecondary)),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              style: const TextStyle(color: Colors.white),
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'e.g., Deep rest, vivid dreams, woke up multiple times...',
                hintStyle: AppTypography.bodyMd(color: AppColorsDark.textMuted),
                filled: true,
                fillColor: AppColorsDark.surface1,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),

            // Save CTA
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorsDark.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _isLoading ? null : _saveSession,
              child: _isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text('Save Sleep Log', style: AppTypography.labelLg(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCard({
    required String label,
    required TimeOfDay time,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final formattedStr = DateFormat('h:mm a').format(dt);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColorsDark.surface1,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColorsDark.surface2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: AppColorsDark.purple),
                const SizedBox(width: 6),
                Text(label, style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
              ],
            ),
            const SizedBox(height: 8),
            Text(formattedStr, style: AppTypography.metricLg(color: Colors.white).copyWith(fontSize: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildBiomarkerInput({
    required TextEditingController controller,
    required String label,
    required String unit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: AppTypography.metricLg(color: Colors.white).copyWith(fontSize: 20),
          decoration: InputDecoration(
            suffixText: unit,
            suffixStyle: AppTypography.labelSm(color: AppColorsDark.textMuted),
            filled: true,
            fillColor: AppColorsDark.surface1,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
