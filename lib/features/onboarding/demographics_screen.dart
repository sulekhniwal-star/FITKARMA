import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import '../../shared/widgets/bento_card.dart';
import 'onboarding_providers.dart';

class DemographicsScreen extends ConsumerStatefulWidget {
  const DemographicsScreen({super.key});

  @override
  ConsumerState<DemographicsScreen> createState() => _DemographicsScreenState();
}

class _DemographicsScreenState extends ConsumerState<DemographicsScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String _selectedGender = 'Female';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _submit() async {
    final name = _nameController.text.trim();
    final ageStr = _ageController.text.trim();
    final heightStr = _heightController.text.trim();
    final weightStr = _weightController.text.trim();

    if (name.isEmpty || ageStr.isEmpty || heightStr.isEmpty || weightStr.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.black, size: 20),
              const SizedBox(width: 8),
              Text(
                'Please fill all fields first',
                style: AppTypography.labelLg(color: Colors.black).copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: AppColorsDark.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    debugPrint('DemographicsScreen: Submitting...');

    try {
      final age = int.tryParse(ageStr) ?? 25;
      final height = double.tryParse(heightStr) ?? 165.0;
      final weight = double.tryParse(weightStr) ?? 60.0;

      debugPrint('DemographicsScreen: Saving to provider...');
      await ref.read(authProvider.notifier).saveDemographics(
            name: name,
            age: age,
            height: height,
            weight: weight,
            gender: _selectedGender,
          );

      debugPrint('DemographicsScreen: Save complete. Navigating...');
      if (mounted) {
        context.go('/onboarding/permissions');
      }
    } catch (e) {
      debugPrint('DemographicsScreen: Error during submit: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Error: $e',
                    style: AppTypography.labelLg(color: Colors.white).copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColorsDark.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold.patternC(
      gradient: AppGradients.heroDeep,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 36),
                    // Header Icon
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColorsDark.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '👤',
                            style: TextStyle(fontSize: 48),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'Tell us about yourself',
                        style: AppTypography.displayLg(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        'Help us customize your dietary calorie limits, ideal protein targets, and Ayurvedic recommendations.',
                        style: AppTypography.bodyMd(color: AppColorsDark.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Card 1: Name Details
                    GlassCard(
                      glowColor: AppColorsDark.primary.withValues(alpha: 0.05),
                      child: _buildTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        hint: 'Enter your name',
                        icon: Icons.person_outline_rounded,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card 2: Demographic Metrics
                    GlassCard(
                      glowColor: AppColorsDark.secondary.withValues(alpha: 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Physical Metrics',
                            style: AppTypography.h3(color: Colors.white).copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: _ageController,
                            label: 'Age',
                            hint: 'Enter your age',
                            icon: Icons.calendar_today_rounded,
                            keyboardType: TextInputType.number,
                            suffix: 'years',
                          ),
                          const SizedBox(height: 20),
                          _buildGenderPills(),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: _heightController,
                                  label: 'Height',
                                  hint: 'e.g. 175',
                                  icon: Icons.height_rounded,
                                  keyboardType: TextInputType.number,
                                  suffix: 'cm',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  controller: _weightController,
                                  label: 'Weight',
                                  hint: 'e.g. 70',
                                  icon: Icons.monitor_weight_outlined,
                                  keyboardType: TextInputType.number,
                                  suffix: 'kg',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Continue CTA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColorsDark.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColorsDark.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(
                          'Continue',
                          style: AppTypography.h3(color: Colors.white).copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelLg(color: AppColorsDark.textSecondary).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: AppTypography.bodyLg(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMd(color: AppColorsDark.textMuted),
            prefixIcon: Icon(icon, color: AppColorsDark.primary, size: 20),
            suffixText: suffix,
            suffixStyle: AppTypography.labelLg(color: AppColorsDark.textSecondary).copyWith(
              fontWeight: FontWeight.bold,
            ),
            filled: true,
            fillColor: AppColorsDark.surface0.withValues(alpha: 0.4),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColorsDark.glassBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColorsDark.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderPills() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: AppTypography.labelLg(color: AppColorsDark.textSecondary).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: ['Male', 'Female', 'Other'].map((g) {
            final isSelected = _selectedGender == g;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedGender = g),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColorsDark.primary.withValues(alpha: 0.15)
                        : AppColorsDark.surface0.withValues(alpha: 0.4),
                    border: Border.all(
                      color: isSelected ? AppColorsDark.primary : AppColorsDark.glassBorder,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      g,
                      style: AppTypography.bodyLg(
                        color: isSelected ? Colors.white : AppColorsDark.textSecondary,
                      ).copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
