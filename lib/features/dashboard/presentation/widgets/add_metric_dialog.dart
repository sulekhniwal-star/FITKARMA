import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../dashboard_controller.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/bilingual_label.dart';

class AddMetricDialog extends ConsumerStatefulWidget {
  const AddMetricDialog({super.key});

  @override
  ConsumerState<AddMetricDialog> createState() => _AddMetricDialogState();
}

class _AddMetricDialogState extends ConsumerState<AddMetricDialog> {
  final _stepsController = TextEditingController();
  final _minsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const BilingualLabel(
        english: 'Add Activity',
        hindi: 'गतिविधि जोड़ें',
        englishSize: 20,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Water Quick Add
            ListTile(
              leading: const Icon(Icons.water_drop, color: Colors.teal),
              title: const Text('Add Glass of Water'),
              subtitle: const Text('पानी का गिलास जोड़ें'),
              onTap: () {
                ref.read(dashboardControllerProvider.notifier).addWater();
                Navigator.pop(context);
              },
            ),
            const Divider(),
            // Steps Add
            TextField(
              controller: _stepsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total Steps Today',
                hintText: 'आज के कुल कदम',
              ),
            ),
            const SizedBox(height: 16),
            // Minutes Add
            TextField(
              controller: _minsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Active Minutes',
                hintText: 'सक्रिय मिनट',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final steps = int.tryParse(_stepsController.text);
            final mins = int.tryParse(_minsController.text);

            if (steps != null) {
              ref.read(dashboardControllerProvider.notifier).updateSteps(steps);
            }
            if (mins != null) {
              ref.read(dashboardControllerProvider.notifier).addMinutes(mins);
            }
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryOrange,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
