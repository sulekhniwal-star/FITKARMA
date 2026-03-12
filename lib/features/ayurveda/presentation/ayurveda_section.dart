import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../domain/models/dosha_profile.dart';
import 'quiz/dosha_quiz_screen.dart';
import 'widgets/dosha_donut_chart.dart';

class AyurvedaSection extends ConsumerWidget {
  const AyurvedaSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<DoshaProfile>('dosha_profile').listenable(),
      builder: (context, box, _) {
        final profile = box.get('current');

        if (profile == null) {
          return _buildQuizPrompt(context);
        }

        return _buildDoshaCard(context, profile);
      },
    );
  }

  Widget _buildQuizPrompt(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.indigo.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.self_improvement, size: 48, color: Colors.indigo),
            const SizedBox(height: 12),
            const BilingualLabel(
              english: 'Discover Your Dosha',
              hindi: 'अपने दोष को जानें',
              englishSize: 18,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DoshaQuizScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoshaCard(BuildContext context, DoshaProfile profile) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            DoshaDonutChart(
              vata: profile.vata,
              pitta: profile.pitta,
              kapha: profile.kapha,
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   BilingualLabel(
                    english: 'Your Dosha: ${profile.dominantDosha}',
                    hindi: 'आपका दोष: ${profile.dominantDosha}',
                    englishSize: 18,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Profile based on last quiz balance.',
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _DoshaDot(color: Colors.indigo, label: 'V'),
                      const SizedBox(width: 8),
                      _DoshaDot(color: Colors.redAccent, label: 'P'),
                      const SizedBox(width: 8),
                      _DoshaDot(color: Colors.green, label: 'K'),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DoshaQuizScreen()),
                );
              },
              icon: const Icon(Icons.refresh, size: 20),
              color: AppColors.textGrey,
            ),
          ],
        ),
      ),
    );
  }
}

class _DoshaDot extends StatelessWidget {
  final Color color;
  final String label;

  const _DoshaDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
