enum DoshaType { vata, pitta, kapha }

class DoshaQuestion {
  final String question;
  final String vataOption;
  final String pittaOption;
  final String kaphaOption;

  const DoshaQuestion({
    required this.question,
    required this.vataOption,
    required this.pittaOption,
    required this.kaphaOption,
  });
}

class DoshaResult {
  final DoshaType dominant;
  final double vataPercentage;
  final double pittaPercentage;
  final double kaphaPercentage;

  const DoshaResult({
    required this.dominant,
    required this.vataPercentage,
    required this.pittaPercentage,
    required this.kaphaPercentage,
  });

  @override
  String toString() => 'Dominant: ${dominant.name.toUpperCase()} (V: ${vataPercentage.toStringAsFixed(0)}%, P: ${pittaPercentage.toStringAsFixed(0)}%, K: ${kaphaPercentage.toStringAsFixed(0)}%)';
}

final List<DoshaQuestion> doshaQuestions = [
  const DoshaQuestion(
    question: "How would you describe your body frame?",
    vataOption: "Lean, slender, and bony. Find it hard to gain weight.",
    pittaOption: "Medium build, muscular, and well-proportioned.",
    kaphaOption: "Broad, sturdy, and heavy. Gain weight easily.",
  ),
  const DoshaQuestion(
    question: "What is your skin texture like?",
    vataOption: "Dry, rough, thin, and prone to cracking.",
    pittaOption: "Soft, warm, oily, and prone to redness/moles.",
    kaphaOption: "Thick, smooth, cool, and slightly oily.",
  ),
  const DoshaQuestion(
    question: "How is your energy level throughout the day?",
    vataOption: "Bursts of energy followed by quick fatigue.",
    pittaOption: "Steady, strong, and driven. Can be intense.",
    kaphaOption: "Slow, steady, and high endurance. Hard to start.",
  ),
  const DoshaQuestion(
    question: "How do you usually sleep?",
    vataOption: "Light, interrupted, and often less than 6 hours.",
    pittaOption: "Sound and moderate. About 6-8 hours.",
    kaphaOption: "Deep, long, and heavy. More than 8 hours.",
  ),
  const DoshaQuestion(
    question: "How is your digestion and appetite?",
    vataOption: "Irregular appetite. Prone to bloating and gas.",
    pittaOption: "Strong, intense appetite. Prone to acidity.",
    kaphaOption: "Slow, steady appetite. Prone to heaviness.",
  ),
  const DoshaQuestion(
    question: "What is your memory style?",
    vataOption: "Quick to learn, but quick to forget.",
    pittaOption: "Sharp, focused, and precise.",
    kaphaOption: "Slow to learn, but never forgets.",
  ),
  const DoshaQuestion(
    question: "How do you usually speak?",
    vataOption: "Fast, talkative, and sometimes scattered.",
    pittaOption: "Clear, direct, and convincing.",
    kaphaOption: "Slow, melodious, and deliberate.",
  ),
  const DoshaQuestion(
    question: "What is your emotional nature?",
    vataOption: "Fearful, anxious, and prone to worry.",
    pittaOption: "Irritable, competitive, and prone to anger.",
    kaphaOption: "Calm, loving, and prone to attachment.",
  ),
  const DoshaQuestion(
    question: "What temperature do you prefer?",
    vataOption: "Warm weather. Dislike cold and wind.",
    pittaOption: "Cool weather. Dislike heat and intensity.",
    kaphaOption: "Warm and dry weather. Dislike damp cold.",
  ),
  const DoshaQuestion(
    question: "How is your appetite?",
    vataOption: "Variable, I often forget to eat.",
    pittaOption: "Intense, I get 'hangry' if I miss a meal.",
    kaphaOption: "Constant but low, I can skip meals easily.",
  ),
];
