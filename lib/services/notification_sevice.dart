import 'dart:io';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  
  tz.initializeTimeZones();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: DarwinInitializationSettings(),
  );

  final bool? initialized = await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  if (!initialized!) {
    print("Flutter Local Notifications Plugin initialization failed.");
  }
  else {
    print("Flutter Local Notifications Plugin initialized successfully.");
  }
}

Future<void> scheduleMilestoneNotifications() async {
  final List<Map<String, dynamic>> milestones = [
    {
      "duration": Duration(hours: 24),
      "message":
          "🎉 Congratulations! You've been smoke-free for 24 hours. Every hour matters — keep going!"
    },
    {
      "duration": Duration(days: 3),
      "message":
          "💪 3 days strong! Your body is already healing. Stay focused!"
    },
    {
      "duration": Duration(days: 7),
      "message":
          "🔥 1 week smoke-free! You're building powerful momentum!"
    },
    {
      "duration": Duration(days: 30),
      "message":
          "🌟 1 month smoke-free! This is a life-changing achievement!"
    },
  ];

  await createScheduledNotification(milestones);
}

Future<void> createScheduledNotification(List<Map<String, dynamic>> milestones) async {
  for (var i = 0; i < milestones.length; i++) {
    final scheduledTime = tz.TZDateTime.now(tz.local).add(milestones[i]["duration"]);
  print("now: ${tz.TZDateTime.now(tz.local)}");
    print("📅 Scheduling notification [${i}] at: $scheduledTime "
        "(${milestones[i]["duration"]}) "
        "Message: ${milestones[i]["message"]}");

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        Random().nextInt(100000), // Unique ID
        "Milestone Achieved 🚀",
        milestones[i]["message"],
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'milestone_channel',
          'Milestone Notifications',
          channelDescription: 'Motivational milestone achievements',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    final pending = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print("pending notifications: ${pending.map((toElement) => {toElement.title, toElement.body, toElement.id})}");
    print("objective scheduled: ${milestones[i]["message"]}");
    } catch (e) {
      print("Error scheduling notification: $e");
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