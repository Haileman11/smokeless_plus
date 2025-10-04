import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> scheduleDailyReminder(TimeOfDay time) async {
  final now = tz.TZDateTime.now(tz.local);
  var scheduledDate = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    time.hour, // 8 PM daily
    time.minute,
  );

  // If the scheduled time has passed today, schedule for tomorrow
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0, // Fixed ID for daily reminder
    "Daily Check-in 💪",
    "Stay strong! Track your progress and celebrate your smoke-free journey.",
    scheduledDate,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_reminder_channel',
        'Daily Reminders',
        channelDescription: 'Daily motivation and tracking reminders',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time, // Repeats daily
  );
}

// Modify initNotifications to include notification action handling
// Add this new test function
Future<void> sendTestNotification() async {
  final now = tz.TZDateTime.now(tz.local);
  final scheduledTime = now.add(const Duration(seconds: 10));

  try {
    // First ensure the channel exists
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'test_channel',
      'Test Notifications',
      description: 'Test notification channel',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      99999,
      "Test Notification",
      "If you see this, scheduled notifications are working!",
      scheduledTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.high,
          enableVibration: true,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: 'default',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    print("Test notification scheduled for: $scheduledTime");
    final pending =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print("Pending notifications: ${pending.length}");
  } catch (e) {
    print("Error scheduling test notification: $e");
  }
}


// Add a method to cancel all notifications
Future<void> cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> scheduleMilestoneNotifications() async {
  // Clear existing milestone notifications first
  await cancelMilestoneNotifications();

  final List<Map<String, dynamic>> milestones = [
    {
      "id": 1001, // Fixed ID for 24 hours milestone
      "duration": Duration(hours: 24),
      "message":
          "🎉 Congratulations! You've been smoke-free for 24 hours. Every hour matters — keep going!"
    },
    {
      "id": 1002, // Fixed ID for 3 days milestone
      "duration": Duration(days: 3),
      "message": "💪 3 days strong! Your body is already healing. Stay focused!"
    },
    {
      "id": 1003, // Fixed ID for 1 week milestone
      "duration": Duration(days: 7),
      "message": "🔥 1 week smoke-free! You're building powerful momentum!"
    },
    {
      "id": 1004, // Fixed ID for 1 month milestone
      "duration": Duration(days: 30),
      "message": "🌟 1 month smoke-free! This is a life-changing achievement!"
    },
  ];

  await createScheduledNotification(milestones);
}

// Add this new function to cancel milestone notifications
Future<void> cancelDailyNotifications() async {
  // Cancel notifications with IDs 1001-1004
  
  await flutterLocalNotificationsPlugin.cancel(0);
  
}
// Add this new function to cancel milestone notifications
Future<void> cancelMilestoneNotifications() async {
  // Cancel notifications with IDs 1001-1004
  for (int id = 1001; id <= 1004; id++) {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}

// Add this at the beginning of the file after imports
const String MILESTONE_CHANNEL_ID = 'milestone_channel';
const String DAILY_REMINDER_CHANNEL_ID = 'daily_reminder_channel';
const String TEST_CHANNEL_ID = 'test_channel';

// Modify initNotifications
Future<void> initNotifications() async {
  tz.initializeTimeZones();

  // Create channels first
  if (Platform.isAndroid) {
        await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            MILESTONE_CHANNEL_ID,
            'Milestone Notifications',
            description: 'Motivational milestone achievements',
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
          ),
        );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            DAILY_REMINDER_CHANNEL_ID,
            'Daily Reminders',
            description: 'Daily motivation and tracking reminders',
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
          ),
        );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            TEST_CHANNEL_ID,
            'Test Notifications',
            description: 'Test notification channel',
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
          ),
        );
  
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: (id, title, body, payload) async {
      print("iOS notification received: $title");
    },
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      print("Notification clicked: ${details.payload}");
    },
  );
}



Future<void> createScheduledNotification(
    List<Map<String, dynamic>> milestones) async {
  // Cancel all existing notifications first
  await cancelAllNotifications();

  for (var milestone in milestones) {
    final scheduledTime =
        tz.TZDateTime.now(tz.local).add(milestone["duration"]);

    try {
      print("Scheduling milestone ${milestone["id"]} for: $scheduledTime");

      await flutterLocalNotificationsPlugin.zonedSchedule(
        milestone["id"],
        "Milestone Achieved 🚀",
        milestone["message"],
        scheduledTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            MILESTONE_CHANNEL_ID,
            'Milestone Notifications',
            channelDescription: 'Motivational milestone achievements',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      // Verify scheduling
      final pending =
          await flutterLocalNotificationsPlugin.pendingNotificationRequests();
      final scheduled = pending.any((n) => n.id == milestone["id"]);
      print("Milestone ${milestone["id"]} scheduled: $scheduled");
    } catch (e) {
      print("Error scheduling milestone ${milestone["id"]}: $e");
    }
  }
}

Future<void> requestNotificationPermissions() async {
  final IOSFlutterLocalNotificationsPlugin? iosImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();

  await iosImplementation?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> requestAndroidPermissions() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}
