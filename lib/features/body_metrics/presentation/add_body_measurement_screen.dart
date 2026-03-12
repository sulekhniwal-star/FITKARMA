import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../../core/di/providers.dart';
import '../domain/body_measurement_model.dart';
import '../data/body_metrics_repository.dart';

/// Add/Edit body measurement screen
class AddBodyMeasurementScreen extends ConsumerStatefulWidget {
  final String? measurementId;

  const AddBodyMeasurementScreen({super.key, this.measurementId});

  @override
  ConsumerState<AddBodyMeasurementScreen> createState() =>
      _AddBodyMeasurementScreenState();
}

class _AddBodyMeasurementScreenState
    extends ConsumerState<AddBodyMeasurementScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipsController = TextEditingController();
  final _chestController = TextEditingController();
  final _armsController = TextEditingController();
  final _thighsController = TextEditingController();
  final _bodyFatController = TextEditingController();

  DateTime _measurementDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.measurementId != null) {
      _loadMeasurement();
    }
  }

  Future<void> _loadMeasurement() async {
    final repository = ref.read(bodyMetricsRepositoryProvider);
    final measurement = await repository.getById(widget.measurementId!);
    if (measurement != null && mounted) {
      setState(() {
        _measurementDate = measurement.date;
        _weightController.text = measurement.weightKg?.toString() ?? '';
        _heightController.text = measurement.heightCm?.toString() ?? '';
        _waistController.text = measurement.waistCm?.toString() ?? '';
        _hipsController.text = measurement.hipsCm?.toString() ?? '';
        _chestController.text = measurement.chestCm?.toString() ?? '';
        _armsController.text = measurement.armsCm?.toString() ?? '';
        _thighsController.text = measurement.thighsCm?.toString() ?? '';
        _bodyFatController.text = measurement.bodyFatPct?.toString() ?? '';
      });
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _waistController.dispose();
    _hipsController.dispose();
    _chestController.dispose();
    _armsController.dispose();
    _thighsController.dispose();
    _bodyFatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.measurementId != null;

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
          isEditing ? 'Edit Measurement' : 'Add Measurement',
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
            // Date picker
            _buildSectionTitle('Date / तारीख'),
            const SizedBox(height: 8),
            _buildDatePicker(),

            const SizedBox(height: 24),

            // Core metrics
            _buildSectionTitle('Core Metrics / मुख्य माप'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildNumberField(
                    'Weight',
                    'वजन',
                    _weightController,
                    'kg',
                    200,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNumberField(
                    'Height',
                    'ऊंचाई',
                    _heightController,
                    'cm',
                    250,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Body measurements
            _buildSectionTitle('Body Measurements / शरीर के माप'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildNumberField('Waist', 'कमर', _waistCm, 'cm', 200),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNumberField(
                    'Hips',
                    'कूल्हे',
                    _hipsCm,
                    'cm',
                    200,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildNumberField(
                    'Chest',
                    'छाती',
                    _chestCm,
                    'cm',
                    200,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNumberField('Arms', 'बाहें', _armsCm, 'cm', 100),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildNumberField('Thighs', 'जांघें', _thighsCm, 'cm', 100),

            const SizedBox(height: 24),

            // Body fat
            _buildSectionTitle('Body Fat / शरीर में वसा'),
            const SizedBox(height: 8),
            _buildNumberField(
              'Body Fat %',
              'शरीर में वसा %',
              _bodyFatController,
              '%',
              100,
            ),

            const SizedBox(height: 32),

            // Save Button
            PrimaryButton(
              text: isEditing ? 'Update Measurement' : 'Save Measurement',
              isLoading: _isLoading,
              onPressed: _saveMeasurement,
            ),

            const SizedBox(height: 16),

            SecondaryButton(text: 'Cancel', onPressed: () => context.pop()),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Helper getters for text controllers
  TextEditingController get _waistCm => _waistController;
  TextEditingController get _hipsCm => _hipsController;
  TextEditingController get _chestCm => _chestController;
  TextEditingController get _armsCm => _armsController;
  TextEditingController get _thighsCm => _thighsController;

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _measurementDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() => _measurementDate = picked);
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
              '${_measurementDate.day}/${_measurementDate.month}/${_measurementDate.year}',
              style: AppTextStyles.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberField(
    String label,
    String labelHi,
    TextEditingController controller,
    String unit,
    double max,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: '$label ($labelHi)',
        suffixText: unit,
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
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final num = double.tryParse(value);
          if (num == null || num < 0 || num > max) {
            return 'Invalid value';
          }
        }
        return null;
      },
    );
  }

  Future<void> _saveMeasurement() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(bodyMetricsRepositoryProvider);

      final measurement = BodyMeasurement(
        id:
            widget.measurementId ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        userId: '',
        date: _measurementDate,
        weightKg: _weightController.text.isNotEmpty
            ? double.tryParse(_weightController.text)
            : null,
        heightCm: _heightController.text.isNotEmpty
            ? double.tryParse(_heightController.text)
            : null,
        waistCm: _waistController.text.isNotEmpty
            ? double.tryParse(_waistController.text)
            : null,
        hipsCm: _hipsController.text.isNotEmpty
            ? double.tryParse(_hipsController.text)
            : null,
        chestCm: _chestController.text.isNotEmpty
            ? double.tryParse(_chestController.text)
            : null,
        armsCm: _armsController.text.isNotEmpty
            ? double.tryParse(_armsController.text)
            : null,
        thighsCm: _thighsController.text.isNotEmpty
            ? double.tryParse(_thighsController.text)
            : null,
        bodyFatPct: _bodyFatController.text.isNotEmpty
            ? double.tryParse(_bodyFatController.text)
            : null,
        syncStatus: 'pending',
      );

      if (widget.measurementId != null) {
        await repository.updateMeasurement(measurement);
      } else {
        await repository.addMeasurement(measurement);
      }

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving measurement: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
