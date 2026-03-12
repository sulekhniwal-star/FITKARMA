import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'greeting_provider.g.dart';

class Greeting {
  final String english;
  final String hindi;

  const Greeting(this.english, this.hindi);
}

@riverpod
Greeting randomGreeting(RandomGreetingRef ref) {
  final greetings = [
    const Greeting('Good Morning', 'सुप्रभात'),
    const Greeting('Namaste', 'नमस्ते'),
    const Greeting('Stay Hydrated', 'हाइड्रेटेड रहें'),
    const Greeting('Let\'s be Active', 'सक्रिय रहें'),
    const Greeting('Keep it up', 'इसे जारी रखें'),
  ];

  return greetings[Random().nextInt(greetings.length)];
}
