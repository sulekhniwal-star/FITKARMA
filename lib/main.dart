import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/storage/hive_service.dart';
import 'package:fitkarma/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive storage
  await HiveService.init();

  runApp(
    const ProviderScope(
      child: FitKarmaApp(),
    ),
  );
}
