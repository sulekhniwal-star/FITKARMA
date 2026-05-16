import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeWidgetService {
  static const String _androidWidgetProvider = 'FitkarmaAppWidgetProvider';
  static const String _iosWidgetName = 'FitkarmaWidget';

  static Future<void> updateWidgets({
    required int steps,
    required int stepGoal,
    required int karmaXp,
    required bool isPro,
  }) async {
    // Widgets are only supported on Android and iOS. Return early on other platforms to avoid MissingPluginException.
    if (kIsWeb || (defaultTargetPlatform != TargetPlatform.android && defaultTargetPlatform != TargetPlatform.iOS)) {
      return;
    }

    try {
      // Save data variables directly into native AppGroup / SharedPreferences surfaces
      await HomeWidget.saveWidgetData<int>('steps', steps);
      await HomeWidget.saveWidgetData<int>('step_goal', stepGoal);
      await HomeWidget.saveWidgetData<int>('karma_xp', karmaXp);
      await HomeWidget.saveWidgetData<bool>('is_pro', isPro);

      // Request widget layouts update passing target native provider identifiers
      await HomeWidget.updateWidget(
        name: _androidWidgetProvider,
        androidName: _androidWidgetProvider,
        iOSName: _iosWidgetName,
      );
    } catch (e) {
      debugPrint('HomeWidget native bridge update ignored/unavailable: $e');
    }
  }
}

final homeWidgetServiceProvider = Provider<HomeWidgetService>((ref) {
  return HomeWidgetService();
});
