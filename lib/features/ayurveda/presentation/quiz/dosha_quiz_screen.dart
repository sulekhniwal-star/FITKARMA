import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/bilingual_label.dart';
import '../../domain/models/dosha_profile.dart';
import 'package:hive/hive.dart';

class DoshaQuizScreen extends ConsumerStatefulWidget {
  const DoshaQuizScreen({super.key});

  @override
  ConsumerState<DoshaQuizScreen> createState() => _DoshaQuizScreenState();
}

class _DoshaQuizScreenState extends ConsumerState<DoshaQuizScreen> {
  int _currentStep = 0;
  final Map<int, String> _answers = {};

  final List<Map<String, dynamic>> _questions = [
    {
      'questionEn': 'How would you describe your physical build?',
      'questionHi': 'आप अपनी शारीरिक बनावट का वर्णन कैसे करेंगे?',
      'options': [
        {'labelEn': 'Thin, bony, or petite', 'labelHi': 'पतला, पतला या छोटा', 'type': 'vata'},
        {'labelEn': 'Medium, athletic, or well-built', 'labelHi': 'मध्यम, एथलेटिक या सुडौल', 'type': 'pitta'},
        {'labelEn': 'Large, broad, or curvy', 'labelHi': 'बड़ा, चौड़ा या घुमावदार', 'type': 'kapha'},
      ],
    },
    {
      'questionEn': 'How is your digestion and appetite?',
      'questionHi': 'आपका पाचन और भूख कैसी है?',
      'options': [
        {'labelEn': 'Irregular, gas, or bloating', 'labelHi': 'अनियमित, गैस या सूजन', 'type': 'vata'},
        {'labelEn': 'Strong, sharp, or easily hungry', 'labelHi': 'मजबूत, तेज या आसानी से भूख लगना', 'type': 'pitta'},
        {'labelEn': 'Slow, heavy, or steady', 'labelHi': 'धीमा, भारी या स्थिर', 'type': 'kapha'},
      ],
    },
    {
      'questionEn': 'How do you typically respond to stress?',
      'questionHi': 'आप आमतौर पर तनाव के प्रति कैसे प्रतिक्रिया करते हैं?',
      'options': [
        {'labelEn': 'Anxiety, fear, or worry', 'labelHi': 'चिंता, डर या परेशानी', 'type': 'vata'},
        {'labelEn': 'Anger, irritation, or impatience', 'labelHi': 'गुस्सा, जलन या अधीरता', 'type': 'pitta'},
        {'labelEn': 'Calm, withdraw, or slow to react', 'labelHi': 'शांत, हटना या धीमी प्रतिक्रिया', 'type': 'kapha'},
      ],
    },
    {
      'questionEn': 'Describe your sleep pattern.',
      'questionHi': 'अपनी नींद के पैटर्न का वर्णन करें।',
      'options': [
        {'labelEn': 'Light, restless, or insomnia', 'labelHi': 'हल्की, बेचैन या अनिद्रा', 'type': 'vata'},
        {'labelEn': 'Sound, moderate, yet short', 'labelHi': 'अच्छी, मध्यम, फिर भी छोटी', 'type': 'pitta'},
        {'labelEn': 'Deep, heavy, or long', 'labelHi': 'गहरी, भारी या लंबी', 'type': 'kapha'},
      ],
    },
  ];

  void _calculateDosha() async {
    double vata = 0, pitta = 0, kapha = 0;
    _answers.forEach((key, value) {
      if (value == 'vata') vata++;
      if (value == 'pitta') pitta++;
      if (value == 'kapha') kapha++;
    });

    final total = vata + pitta + kapha;
    final profile = DoshaProfile(
      vata: vata / total,
      pitta: pitta / total,
      kapha: kapha / total,
      lastUpdated: DateTime.now(),
    );

    final box = await Hive.openBox<DoshaProfile>('dosha_profile');
    await box.put('current', profile);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentStep];

    return Scaffold(
      appBar: AppBar(
        title: const BilingualLabel(
          english: 'Dosha Quiz',
          hindi: 'दोष प्रश्नोत्तरी',
          englishSize: 18,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentStep + 1) / _questions.length,
              backgroundColor: AppColors.backgroundWarm,
              color: AppColors.primaryOrange,
            ),
            const SizedBox(height: 40),
            BilingualLabel(
              english: q['questionEn'],
              hindi: q['questionHi'],
              englishSize: 22,
            ),
            const SizedBox(height: 32),
            ...List.generate(3, (index) {
              final opt = q['options'][index];
              final isSelected = _answers[_currentStep] == opt['type'];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _answers[_currentStep] = opt['type'];
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryOrange.withOpacity(0.1) : Colors.white,
                      border: Border.all(
                        color: isSelected ? AppColors.primaryOrange : AppColors.borderGrey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: BilingualLabel(
                            english: opt['labelEn'],
                            hindi: opt['labelHi'],
                            englishSize: 16,
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: AppColors.primaryOrange),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  TextButton(
                    onPressed: () => setState(() => _currentStep--),
                    child: const Text('Back'),
                  )
                else
                  const SizedBox(),
                ElevatedButton(
                  onPressed: _answers.containsKey(_currentStep)
                      ? () {
                          if (_currentStep < _questions.length - 1) {
                            setState(() => _currentStep++);
                          } else {
                            _calculateDosha();
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textBlack,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(_currentStep < _questions.length - 1 ? 'Next' : 'Finish'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
