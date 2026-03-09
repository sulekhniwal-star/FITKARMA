import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: FitKarmaApp(flavor: 'Development')));
}

class FitKarmaApp extends StatelessWidget {
  final String flavor;
  const FitKarmaApp({super.key, required this.flavor});
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('FitKarma '),
          ),
        ),
      );
}
