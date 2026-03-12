import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../../core/di/providers.dart';
import '../domain/medication_model.dart';
import '../data/medications_repository.dart';

/// Add/Edit medication screen
class AddMedicationScreen extends ConsumerStatefulWidget {
  final String? medicationId; // If provided, we're editing

  const AddMedicationScreen({super.key, this.medicationId});

  @override
  ConsumerState<AddMedicationScreen> createState() =>
      _AddMedicationScreenState();
}

class _AddMedicationScreenState extends ConsumerState<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _notesController = TextEditingController();

  MedicationCategory _selectedCategory = MedicationCategory.prescription;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  DateTime? _refillDate;
  List<TimeOfDay> _reminderTimes = [const TimeOfDay(hour: 8, minute: 0)];
  String _frequencyDays = 'daily';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.medicationId != null) {
      _loadMedication();
    }
  }

  Future<void> _loadMedication() async {
    final repository = ref.read(medicationsRepositoryProvider);
    final medication = await repository.getById(widget.medicationId!);
    if (medication != null && mounted) {
      setState(() {
        _nameController.text = medication.name;
        _dosageController.text = medication.dosage;
        _notesController.text = medication.notes ?? '';
        _selectedCategory = medication.category;
        _startDate = medication.startDate;
        _endDate = medication.endDate;
        _refillDate = medication.refillDate;
        _frequencyDays = medication.frequency['days'] ?? 'daily';

        // Parse reminder times
        final times = medication.frequency['times'];
        if (times != null && times is List) {
          _reminderTimes = times.map((t) {
            final parts = t.split(':');
            return TimeOfDay(
              hour: int.parse(parts[0]),
              minute: int.parse(parts[1]),
            );
          }).toList();
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.medicationId != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isEditing ? 'Edit Medication' : 'Add Medication',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Medication Name
            _buildSectionTitle('Medication Name / नाम'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration(
                'Enter medication name',
                Icons.medication,
              ),
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter medication name'
                  : null,
            ),

            const SizedBox(height: 24),

            // Dosage
            _buildSectionTitle('Dosage / खुराक'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _dosageController,
              decoration: _inputDecoration(
                'e.g., 500mg, 1 tablet',
                Icons.science,
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter dosage' : null,
            ),

            const SizedBox(height: 24),

            // Category
            _buildSectionTitle('Category / श्रेणी'),
            const SizedBox(height: 8),
            _buildCategorySelector(),

            const SizedBox(height: 24),

            // Frequency
            _buildSectionTitle('Frequency / आवृत्ति'),
            const SizedBox(height: 8),
            _buildFrequencySelector(),

            const SizedBox(height: 24),

            // Reminder Times
            _buildSectionTitle('Reminder Times / अनुस्मारक समय'),
            const SizedBox(height: 8),
            _buildReminderTimes(),

            const SizedBox(height: 24),

            // Start Date
            _buildSectionTitle('Start Date / शुरू होने की तारीख'),
            const SizedBox(height: 8),
            _buildDatePicker(
              date: _startDate,
              onChanged: (date) => setState(() => _startDate = date),
            ),

            const SizedBox(height: 24),

            // End Date (optional)
            _buildSectionTitle('End Date (Optional) / समाप्ति तिथि'),
            const SizedBox(height: 8),
            _buildDatePicker(
              date: _endDate,
              onChanged: (date) => setState(() => _endDate = date),
              firstDate: _startDate,
              placeholder: 'No end date',
            ),

            const SizedBox(height: 24),

            // Refill Date
            _buildSectionTitle('Refill Date / पुनः भरने की तिथि'),
            const SizedBox(height: 8),
            _buildDatePicker(
              date: _refillDate,
              onChanged: (date) => setState(() => _refillDate = date),
              firstDate: DateTime.now(),
              placeholder: 'Set refill reminder',
            ),

            const SizedBox(height: 24),

            // Notes
            _buildSectionTitle('Notes (Optional) / नोट्स'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: _inputDecoration(
                'Any additional notes...',
                Icons.notes,
              ),
            ),

            const SizedBox(height: 32),

            // Save Button
            PrimaryButton(
              text: isEditing ? 'Update Medication' : 'Add Medication',
              isLoading: _isLoading,
              onPressed: _saveMedication,
            ),

            const SizedBox(height: 16),

            // Cancel Button
            SecondaryButton(text: 'Cancel', onPressed: () => context.pop()),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Wrap(
      spacing: 8,
      children: MedicationCategory.values.map((category) {
        final isSelected = _selectedCategory == category;
        return ChoiceChip(
          label: Text(_getCategoryLabel(category)),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() => _selectedCategory = category);
            }
          },
          selectedColor: AppColors.primary.withOpacity(0.2),
          labelStyle: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        );
      }).toList(),
    );
  }

  String _getCategoryLabel(MedicationCategory category) {
    switch (category) {
      case MedicationCategory.prescription:
        return '💊 Prescription';
      case MedicationCategory.otc:
        return '🩹 OTC';
      case MedicationCategory.supplement:
        return '💊 Supplement';
      case MedicationCategory.ayurvedic:
        return '🌿 Ayurvedic';
    }
  }

  Widget _buildFrequencySelector() {
    final frequencies = ['daily', 'weekdays', 'weekends'];
    final labels = {
      'daily': 'Daily / रोज़ाना',
      'weekdays': 'Weekdays / सप्ताह के दिन',
      'weekends': 'Weekends / सप्ताहांत',
    };

    return Wrap(
      spacing: 8,
      children: frequencies.map((freq) {
        final isSelected = _frequencyDays == freq;
        return ChoiceChip(
          label: Text(labels[freq]!),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() => _frequencyDays = freq);
            }
          },
          selectedColor: AppColors.primary.withOpacity(0.2),
          labelStyle: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReminderTimes() {
    return Column(
      children: [
        ..._reminderTimes.asMap().entries.map((entry) {
          final index = entry.key;
          final time = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            time.format(context),
                            style: AppTextStyles.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_reminderTimes.length > 1)
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle,
                      color: AppColors.error,
                    ),
                    onPressed: () => _removeReminderTime(index),
                  ),
              ],
            ),
          );
        }),
        TextButton.icon(
          onPressed: _addReminderTime,
          icon: const Icon(Icons.add_alarm, color: AppColors.primary),
          label: const Text(
            'Add Time',
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Future<void> _selectTime(int index) async {
    final time = await showTimePicker(
      context: context,
      initialTime: _reminderTimes[index],
    );
    if (time != null) {
      setState(() {
        _reminderTimes[index] = time;
      });
    }
  }

  void _addReminderTime() {
    setState(() {
      _reminderTimes.add(const TimeOfDay(hour: 20, minute: 0));
    });
  }

  void _removeReminderTime(int index) {
    setState(() {
      _reminderTimes.removeAt(index);
    });
  }

  Widget _buildDatePicker({
    DateTime? date,
    required Function(DateTime) onChanged,
    DateTime? firstDate,
    String? placeholder,
  }) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: firstDate ?? DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Text(
              date != null
                  ? '${date.day}/${date.month}/${date.year}'
                  : placeholder ?? 'Select date',
              style: AppTextStyles.bodyLarge.copyWith(
                color: date != null
                    ? AppColors.textPrimary
                    : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveMedication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(medicationsRepositoryProvider);

      final medication = Medication(
        id:
            widget.medicationId ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        userId: '', // Will be filled by repository
        name: _nameController.text.trim(),
        dosage: _dosageController.text.trim(),
        frequency: {
          'times': _reminderTimes
              .map(
                (t) =>
                    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}',
              )
              .toList(),
          'days': _frequencyDays,
        },
        startDate: _startDate,
        endDate: _endDate,
        refillDate: _refillDate,
        isActive: true,
        category: _selectedCategory,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        syncStatus: 'pending',
      );

      if (widget.medicationId != null) {
        await repository.updateMedication(medication);
      } else {
        await repository.addMedication(medication);
      }

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving medication: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
