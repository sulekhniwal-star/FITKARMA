import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma_ui/fitkarma_ui.dart';

class DoshaThemeNotifier extends Notifier<DoshaType> {
  @override
  DoshaType build() => DoshaType.pitta;

  void setDosha(DoshaType type) => state = type;
}

final doshaThemeProvider = NotifierProvider<DoshaThemeNotifier, DoshaType>(DoshaThemeNotifier.new);
