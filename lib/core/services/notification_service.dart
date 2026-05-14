import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Set up timezone handling for local notifications
    tz.initializeTimeZones();

    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      return;
    }

    const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: false, // Requested during onboarding explicitly
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle background/foreground navigation payloads if attached
      },
    );
  }

  static Future<bool> requestPermission() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      return false;
    }

    bool granted = false;
    
    // Request for iOS
    final iosImplementation = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (iosImplementation != null) {
      granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      ) ?? false;
    }

    // Request for Android T+ (API 33+)
    final androidImplementation = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      granted = await androidImplementation.requestNotificationsPermission() ?? false;
    }

    return granted;
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'fitkarma_wellness_channel',
          'Wellness Core Reminders',
          channelDescription: 'Scheduled habit and sync reminder alerts',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  static Future<void> _scheduleDailyRepeating({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;

    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'fitkarma_wellness_channel',
          'Wellness Core Reminders',
          channelDescription: 'Scheduled habit and sync reminder alerts',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  static Future<void> scheduleDailyReminders({
    bool hasBpCondition = false,
    bool hasGlucoseCondition = false,
  }) async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;

    // 1. Meal Reminders: Breakfast (8AM), Lunch (1PM), Dinner (7:30PM)
    await _scheduleDailyRepeating(id: 101, title: 'Fuel Your Morning 🌅', body: 'Time for a nourishing breakfast to kickstart your inner agni.', hour: 8, minute: 0, payload: '/home/food');
    await _scheduleDailyRepeating(id: 102, title: 'Midday Recharge 🥗', body: 'Log your balanced lunch to sustain optimal prana & focus.', hour: 13, minute: 0, payload: '/home/food');
    await _scheduleDailyRepeating(id: 103, title: 'Evening Sustenance 🍲', body: 'Enjoy a light, wholesome dinner to prepare for recovery sleep.', hour: 19, minute: 30, payload: '/home/food');

    // 2. Water Reminder (every 2h, 8AM–8PM)
    final waterHours = [8, 10, 12, 14, 16, 18, 20];
    for (int i = 0; i < waterHours.length; i++) {
      await _scheduleDailyRepeating(id: 200 + i, title: 'Hydration Routine 💧', body: 'Drink a fresh glass of water to keep your body revitalized.', hour: waterHours[i], minute: 0, payload: '/water');
    }

    // 3. Medication Reminders (per schedule)
    await _scheduleDailyRepeating(id: 301, title: 'Medication Schedule 💊', body: 'Please verify your scheduled active morning prescriptions.', hour: 9, minute: 0, payload: '/medication');
    await _scheduleDailyRepeating(id: 302, title: 'Evening Dose Reminder 🌙', body: 'Check off your recommended restorative supplements.', hour: 20, minute: 30, payload: '/medication');

    // 4. Streak Maintenance Alert (8PM if no activity logged)
    await _scheduleDailyRepeating(id: 401, title: 'Keep the Fire Alive! 🔥', body: 'Log any wellness activity today before midnight to secure your growing streak.', hour: 20, minute: 0, payload: '/home/dashboard');

    // 5. BP/glucose reminder for users with those conditions
    if (hasBpCondition) {
      await _scheduleDailyRepeating(id: 501, title: 'Blood Pressure Monitor 🫀', body: 'Record your morning systolic/diastolic markers for accurate clinical trends.', hour: 9, minute: 30, payload: '/blood-pressure');
    }
    if (hasGlucoseCondition) {
      await _scheduleDailyRepeating(id: 502, title: 'Fasting Glucose Log 🩸', body: 'Measure your early morning blood sugar for precise endocrinological tracking.', hour: 7, minute: 0, payload: '/glucose');
    }
  }

  // 6. Sync failure notification (after DLQ threshold)
  static Future<void> triggerSyncFailureNotification(int dlqCount) async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;

    await _plugin.show(
      id: 999,
      title: 'Offline Sync Pending ⚠️',
      body: '$dlqCount metric logs queued locally. Background sync will reattempt once connectivity restores.',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'fitkarma_sync_channel',
          'Sync Health Alerts',
          channelDescription: 'Offline synchronization status alerts',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
